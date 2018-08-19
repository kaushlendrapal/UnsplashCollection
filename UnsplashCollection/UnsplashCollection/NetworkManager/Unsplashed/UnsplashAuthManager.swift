//
//  NetworkManager.swift
//  UnsplashCollection
//
//  Created by Pal,Kaushlendra on 12/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import UIKit
import WebKit
import Security

/******************************************************************************
 * UnsplashAuthManager: class have responsivility to launch webview connecting Screen to access the oauth2 token.
 * also parse the consumer token on validating webview redirect url.
 ******************************************************************************/

public class UnsplashAuthManager {
    
    private static let host = "unsplash.com"
    
    public static let publicScope = ["public"]
    public static let allScopes = [
        "public",
        "read_user",
        "write_user",
        "read_photos",
        "write_photos",
        "write_likes",
        "read_collections",
        "write_collections"
    ]
    
    private let appId : String
    private let secret : String
    private let redirectURL : URL
    private let dismissOnMatchURL: URL
    private let scopes : [String]
    private var unsplashToken:UnsplashAccessToken?
    public static var sharedAuthManager : UnsplashAuthManager!
    
    public init(appId: String, secret: String, scopes: [String] = UnsplashAuthManager.publicScope) {
        self.appId = appId
        self.secret = secret
        self.redirectURL = URL(string: "https://unsplashcollectionimages.com/authorize")!
        self.dismissOnMatchURL = URL(string: "https://unsplashcollectionimages.com/authorize")!
        self.scopes = scopes
    }
    
    public func authorizeFromController(controller: UIViewController, completion:@escaping (UnsplashAccessToken?, Error?) -> Void) {
        let connectController = UnsplashConnectController(startURL: self.authURL()!, dismissOnMatchURL: self.dismissOnMatchURL)
        connectController.onWillDismiss = { didCancel in
            if (didCancel) {
                completion(nil, APIError.UserCanceledAuth(406, ""))
            }
        }
        connectController.onMatchedURL = { url in
            self.retrieveAccessTokenFromURL(url: url, completion: completion)
        }
        let navigationController = UINavigationController(rootViewController: connectController)
        controller.present(navigationController, animated: true, completion: nil)
    }
    
    private func retrieveAccessTokenFromURL(url: URL, completion: @escaping ((UnsplashAccessToken?, Error?) -> Void)) {
        let (code, error) = extractCodeFromRedirectURL(url: url)
        
        if let e = error {
            completion(nil, e)
            return
        }
        
        var authRequestHealper = OAuthRequestBuilder(accessToken: nil, requestType: .post)
        let requestParams = accessTokenURL(code: code!).queryPairs
        authRequestHealper.buildAuthorizationRequest(withQuery: requestParams)
        NetworkManager.sharedManager.makeNetworkCall(requestHelper: authRequestHealper) { (jsonObject, error) in
            let jsonResult = self.handleJSONResponse(responseObject: jsonObject, httpError: error, ofResultType: UnsplashAccessToken.self)
            switch jsonResult {
            case JSONResult.failure(_):
                print("")
                completion(nil, WebServiceError.APIError(400, "") )
            case JSONResult.success(let token):
                self.unsplashToken = token
                completion(token, nil)
                print("")
            default:
                print("")
            }
        }
        
    }
    
    private func authURL() -> URL? {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = UnsplashAuthManager.host
        components.path = "/oauth/authorize"

        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: self.appId),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "scope", value: self.scopes.joined(separator: "+")),
        ]
        return components.url
    }
    
    private func accessTokenURL(code: String) -> URL {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = UnsplashAuthManager.host
        components.path = "/oauth/token"
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: self.appId),
            URLQueryItem(name: "client_secret", value: self.secret),
            URLQueryItem(name: "redirect_uri", value: self.redirectURL.absoluteString),
            URLQueryItem(name: "code", value: code),
        ]
        return components.url!
    }
    
    private func extractCodeFromRedirectURL(url: URL) -> (String?, Error?) {
        let pairs = url.queryPairs
        if let error = pairs["error"] {
            return (nil, APIError.UserCanceledAuth(401, error))
        } else {
            let code = pairs["code"]!
            return (code, nil)
        }
    }
    
    private func extractErrorFromData(data: NSData) -> Error? {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String:String]
            return APIError.UnsupportedResponseType(500, json!["error_description"] ?? "error_description")
        } catch {
            return nil
        }
    }
    
    public func getAccessToken() -> UnsplashAccessToken? {
        if (self.unsplashToken == nil) {
            return UnsplashAccessToken(appId: "8ef42698e366832076e1ab8e822fe441141239a022dda4f1d8c07c83547d6ac6", accessToken: nil, refreshToken: nil)
        }
        return self.unsplashToken
    }
    
    public func clearAccessToken() -> Bool {
        return true
    }
    
    func handleJSONResponse<T: Decodable>(responseObject: Any?, httpError: Error?, ofResultType resultType: T.Type) -> JSONResult<T> {
        if let response = responseObject {
            if let resultInfo = JSONDecoder.convertResponse(response, ofType: resultType) {
                return JSONResult.success(resultInfo)
            } else if let resultInfo = JSONDecoder.convertResponse(response, ofType: TCResultData.self) {
                return JSONResult.successWithResult(resultInfo)
            } else {
                return JSONResult.failure(.parserError(nil, nil))
            }
        } else {
            return JSONResult.failure(.generalError(NSLocalizedString("Connection Error", comment: "Connection Error")))
        }
    }
}

class UnsplashConnectController : UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    
    var onWillDismiss: ((_ didCancel: Bool) -> Void)?
    var onMatchedURL: ((_ url: URL) -> Void)?
    
    var cancelButton: UIBarButtonItem?
    
    let startURL : URL
    let dismissOnMatchURL : URL
    
    init(startURL: URL, dismissOnMatchURL: URL) {
        self.startURL = startURL
        self.dismissOnMatchURL = dismissOnMatchURL
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Access to Unsplash"
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.view.backgroundColor = UIColor.white
        
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(sender:)) )
        self.navigationItem.rightBarButtonItem = self.cancelButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !webView.canGoBack {
            loadURL(url: startURL)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if self.dimissURLMatchesURL(url: url) {
                self.onMatchedURL?(url)
                self.dismiss(animated: true)
                return decisionHandler(.cancel)
            }
        }
        return decisionHandler(.allow)
    }

    func loadURL(url: URL) {
        webView.load(URLRequest(url: url as URL))
    }
    
    func dimissURLMatchesURL(url: URL) -> Bool {
        if (url.scheme == self.dismissOnMatchURL.scheme &&
            url.host == self.dismissOnMatchURL.host &&
            url.path == self.dismissOnMatchURL.path) {
            return true
        }
        return false
    }
    
    func showHideBackButton(show: Bool) {
        navigationItem.leftBarButtonItem = show ? UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(goBack(sender:))) : nil
    }
    
    @objc func goBack(sender: AnyObject?) {
        webView.goBack()
    }
    
    @objc func cancel(sender: AnyObject?) {
        dismiss(asCancel: true, animated: (sender != nil))
    }
    
    func dismiss(animated: Bool) {
        dismiss(asCancel: false, animated: animated)
    }
    
    func dismiss(asCancel: Bool, animated: Bool) {
        webView.stopLoading()
        
        self.onWillDismiss?(asCancel)
        presentingViewController?.dismiss(animated: animated, completion: nil)
    }
}

public enum APIError : Error {
        /// The client is not authorized to request an access token using this method.
        case UnauthorizedClient(Int, String)
        
        /// The resource owner or authorization server denied the request.
        case AccessDenied(Int, String)
        
        /// The authorization server does not support obtaining an access token using this method.
        case UnsupportedResponseType(Int, String)
        
        /// The requested scope is invalid, unknown, or malformed.
        case InvalidScope(Int, String)
        
        /// The authorization server encountered an unexpected condition that prevented it from
        /// fulfilling the request.
        case ServerError(Int, String)
        
        /// Client authentication failed due to unknown client, no client authentication included,
        /// or unsupported authentication method.
        case InvalidClient(Int, String)
        
        /// The request is missing a required parameter, includes an unsupported parameter value, or
        /// is otherwise malformed.
        case InvalidRequest(Int, String)
        
        /// The provided authorization grant is invalid, expired, revoked, does not match the
        /// redirection URI used in the authorization request, or was issued to another client.
        case InvalidGrant(Int, String)
        
        /// The authorization server is currently unable to handle the request due to a temporary
        /// overloading or maintenance of the server.
        case TemporarilyUnavailable(Int, String)
        
        // The user canceled the authorization process.
        case UserCanceledAuth(Int, String)
        
        /// Some other error.
        case Unknown
    
}
