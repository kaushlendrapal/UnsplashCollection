//
//  Util.swift
//  UnsplashCollectionTests
//
//  Created by Pal,Kaushlendra on 19/08/18.
//  Copyright © 2018 Pal,Kaushlendra. All rights reserved.
//

import Foundation
@testable import UnsplashCollection

class Util {
    
    static let searchCriteria = SearchCriteria(perPage: 100, orderBy: "popular", orientation: "squarish", searchText: "Nature")

    class func buildRequestHelperForImageSearch() -> (RequestHelper) {
        let requestParamaters:[String: Any] = ["page": Int(2), "per_page": searchCriteria.perPage, "order_by": searchCriteria.orderBy, "orientation": searchCriteria.orientation, "query": searchCriteria.searchText]
        var imageSearchRequest = ImageSearchRequestBuilder(accessToken: NetworkManager.sharedManager.unsplashToken)
        imageSearchRequest.photoListRequest(withQuery: requestParamaters)
        
        return imageSearchRequest
    }
    
    class func getdumyDataforImageList() -> ([USImage]) {
        let unspalshedImageData = Util.getResponseDataForImage()
        let jsonDecoder = JSONDecoder()
        let imageModel: USImage = try! jsonDecoder.decode(USImage.self, from: unspalshedImageData)
        
        return [imageModel, imageModel, imageModel]
    }
    
    class func getResponseDataForImage() -> (Data) {
        let response: String = """
        {
            "id": "1FrPE4Vfofo",
            "created_at": "2017-09-13T18:02:12-04:00",
            "updated_at": "2018-05-18T13:26:19-04:00",
            "width": 4560,
            "height": 5481,
            "color": "#C2CDC2",
            "description": null,
            "urls": {
                "raw": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=d100a59ae00600b86ce252417b32b415",
                "full": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=10a7b61b75d692c85ac64a19c732f46c",
                "regular": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=986e68714c7f274cf79528fbb06886fe",
                "small": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=68915fac1bbcc9ddf81674d210b690c9",
                "thumb": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=d4f75ee1029b0f1bde8dbde5376dfe4d"
            },
            "links": {
                "self": "https://api.unsplash.com/photos/1FrPE4Vfofo",
                "html": "https://unsplash.com/photos/1FrPE4Vfofo",
                "download": "https://unsplash.com/photos/1FrPE4Vfofo/download",
                "download_location": "https://api.unsplash.com/photos/1FrPE4Vfofo/download"
            },
            "categories": [],
            "sponsored": false,
            "likes": 76,
            "liked_by_user": false,
            "current_user_collections": [],
            "slug": null,
            "user": {
                "id": "rsut7tf8Tkk",
                "updated_at": "2018-08-15T09:31:38-04:00",
                "username": "ahmedcarter",
                "name": "Ahmed Carter",
                "first_name": "Ahmed",
                "last_name": "Carter",
                "twitter_username": "AhmedCarter",
                "portfolio_url": null,
                "bio": "Selfmade Photographer   Instagram / @ahmedcarter",
                "location": "Abu Dhabi",
                "links": {
                    "self": "https://api.unsplash.com/users/ahmedcarter",
                    "html": "https://unsplash.com/@ahmedcarter",
                    "photos": "https://api.unsplash.com/users/ahmedcarter/photos",
                    "likes": "https://api.unsplash.com/users/ahmedcarter/likes",
                    "portfolio": "https://api.unsplash.com/users/ahmedcarter/portfolio",
                    "following": "https://api.unsplash.com/users/ahmedcarter/following",
                    "followers": "https://api.unsplash.com/users/ahmedcarter/followers"
                },
                "profile_image": {
                    "small": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=fe69b85065b24ae62d415650ba47b409",
                    "medium": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=adcc2fc3259393f6348bb39205a61ef5",
                    "large": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=2e3a8c1cbead6884470c6d8dcc5721db"
                },
                "instagram_username": "Ahmedcarter",
                "total_collections": 0,
                "total_likes": 20,
                "total_photos": 35
            },
            "tags": [
                {
                    "title": "man"
                },
                {
                    "title": "woman"
                },
                {
                    "title": "tattoo"
                },
                {
                    "title": "head"
                },
                {
                    "title": "hand"
                },
                {
                    "title": "shite"
                },
                {
                    "title": "silk"
                },
                {
                    "title": "beach"
                },
                {
                    "title": "desert"
                },
                {
                    "title": "sand"
                },
                {
                    "title": "henna"
                },
                {
                    "title": "girl"
                },
                {
                    "title": "bald"
                },
                {
                    "title": "heena"
                }
            ],
            "photo_tags": [
                {
                    "title": "man"
                },
                {
                    "title": "woman"
                },
                {
                    "title": "tattoo"
                },
                {
                    "title": "head"
                },
                {
                    "title": "hand"
                }
            ]
        }
        """
        let imageData = response.data(using: .utf8)!
        
        return imageData
    }
    
   class  func getResponseDataForImages() -> (Data) {
        let response: String = """
        { "results": [
        {
            "id": "1FrPE4Vfofo",
            "created_at": "2017-09-13T18:02:12-04:00",
            "updated_at": "2018-05-18T13:26:19-04:00",
            "width": 4560,
            "height": 5481,
            "color": "#C2CDC2",
            "description": null,
            "urls": {
                "raw": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=d100a59ae00600b86ce252417b32b415",
                "full": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=10a7b61b75d692c85ac64a19c732f46c",
                "regular": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=986e68714c7f274cf79528fbb06886fe",
                "small": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=68915fac1bbcc9ddf81674d210b690c9",
                "thumb": "https://images.unsplash.com/photo-1505339948821-557408df5c28?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=d4f75ee1029b0f1bde8dbde5376dfe4d"
            },
            "links": {
                "self": "https://api.unsplash.com/photos/1FrPE4Vfofo",
                "html": "https://unsplash.com/photos/1FrPE4Vfofo",
                "download": "https://unsplash.com/photos/1FrPE4Vfofo/download",
                "download_location": "https://api.unsplash.com/photos/1FrPE4Vfofo/download"
            },
            "categories": [],
            "sponsored": false,
            "likes": 76,
            "liked_by_user": false,
            "current_user_collections": [],
            "slug": null,
            "user": {
                "id": "rsut7tf8Tkk",
                "updated_at": "2018-08-15T09:31:38-04:00",
                "username": "ahmedcarter",
                "name": "Ahmed Carter",
                "first_name": "Ahmed",
                "last_name": "Carter",
                "twitter_username": "AhmedCarter",
                "portfolio_url": null,
                "bio": "Selfmade Photographer   Instagram / @ahmedcarter",
                "location": "Abu Dhabi",
                "links": {
                    "self": "https://api.unsplash.com/users/ahmedcarter",
                    "html": "https://unsplash.com/@ahmedcarter",
                    "photos": "https://api.unsplash.com/users/ahmedcarter/photos",
                    "likes": "https://api.unsplash.com/users/ahmedcarter/likes",
                    "portfolio": "https://api.unsplash.com/users/ahmedcarter/portfolio",
                    "following": "https://api.unsplash.com/users/ahmedcarter/following",
                    "followers": "https://api.unsplash.com/users/ahmedcarter/followers"
                },
                "profile_image": {
                    "small": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=fe69b85065b24ae62d415650ba47b409",
                    "medium": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=adcc2fc3259393f6348bb39205a61ef5",
                    "large": "https://images.unsplash.com/profile-1504617136920-ca9cf3352021?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=2e3a8c1cbead6884470c6d8dcc5721db"
                },
                "instagram_username": "Ahmedcarter",
                "total_collections": 0,
                "total_likes": 20,
                "total_photos": 35
            },
            "tags": [
                {
                    "title": "man"
                },
                {
                    "title": "woman"
                },
                {
                    "title": "tattoo"
                },
                {
                    "title": "head"
                },
                {
                    "title": "hand"
                },
                {
                    "title": "shite"
                },
                {
                    "title": "silk"
                },
                {
                    "title": "beach"
                },
                {
                    "title": "desert"
                },
                {
                    "title": "sand"
                },
                {
                    "title": "henna"
                },
                {
                    "title": "girl"
                },
                {
                    "title": "bald"
                },
                {
                    "title": "heena"
                }
            ],
            "photo_tags": [
                {
                    "title": "man"
                },
                {
                    "title": "woman"
                },
                {
                    "title": "tattoo"
                },
                {
                    "title": "head"
                },
                {
                    "title": "hand"
                }
            ]
        },
        {
            "id": "Vv5v5XcnvdY",
            "created_at": "2017-11-27T23:52:28-05:00",
            "updated_at": "2018-05-18T13:41:22-04:00",
            "width": 3456,
            "height": 4320,
            "color": "#10080A",
            "description": null,
            "urls": {
                "raw": "https://images.unsplash.com/photo-1511844698123-7ed6e7a44189?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=9c1f49c9596e96c44cae3cbbbc90005f",
                "full": "https://images.unsplash.com/photo-1511844698123-7ed6e7a44189?ixlib=rb-0.3.5&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=cd58578852ea26f1a865c48e52640dfa",
                "regular": "https://images.unsplash.com/photo-1511844698123-7ed6e7a44189?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=6d19d1169bb1157b3f05f963ee70ef42",
                "small": "https://images.unsplash.com/photo-1511844698123-7ed6e7a44189?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=15520c26db359bb3934938c318334126",
                "thumb": "https://images.unsplash.com/photo-1511844698123-7ed6e7a44189?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjMzNjM1fQ&s=9b1557c9eed416a6c19bb92236946a8f"
            },
            "links": {
                "self": "https://api.unsplash.com/photos/Vv5v5XcnvdY",
                "html": "https://unsplash.com/photos/Vv5v5XcnvdY",
                "download": "https://unsplash.com/photos/Vv5v5XcnvdY/download",
                "download_location": "https://api.unsplash.com/photos/Vv5v5XcnvdY/download"
            },
            "categories": [],
            "sponsored": false,
            "likes": 24,
            "liked_by_user": false,
            "current_user_collections": [],
            "slug": null,
            "user": {
                "id": "PHsntJcXgGQ",
                "updated_at": "2018-07-06T13:43:24-04:00",
                "username": "pawan9472",
                "name": "Pawan Sharma",
                "first_name": "Pawan",
                "last_name": "Sharma",
                "twitter_username": "ps9472",
                "portfolio_url": null,
                "bio": "Love travel, wish to be close to nature, amateur photographer.... ",
                "location": "New Delhi ",
                "links": {
                    "self": "https://api.unsplash.com/users/pawan9472",
                    "html": "https://unsplash.com/@pawan9472",
                    "photos": "https://api.unsplash.com/users/pawan9472/photos",
                    "likes": "https://api.unsplash.com/users/pawan9472/likes",
                    "portfolio": "https://api.unsplash.com/users/pawan9472/portfolio",
                    "following": "https://api.unsplash.com/users/pawan9472/following",
                    "followers": "https://api.unsplash.com/users/pawan9472/followers"
                },
                "profile_image": {
                    "small": "https://images.unsplash.com/profile-1504606563044-d287904c228e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=b02d9cf30666996c937531fcbf69b9da",
                    "medium": "https://images.unsplash.com/profile-1504606563044-d287904c228e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=03bba79dc6b8f1a418e99202ce6ad540",
                    "large": "https://images.unsplash.com/profile-1504606563044-d287904c228e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=282e9485bfe5d014cfb04aa62eaff8a9"
                },
                "instagram_username": "ps9472",
                "total_collections": 0,
                "total_likes": 166,
                "total_photos": 147
            },
            "tags": [
                {
                    "title": "man"
                },
                {
                    "title": "male"
                },
                {
                    "title": "elderly"
                },
                {
                    "title": "old"
                },
                {
                    "title": "face"
                },
                {
                    "title": "portrait"
                },
                {
                    "title": "beard"
                },
                {
                    "title": "paint"
                },
                {
                    "title": "orange"
                },
                {
                    "title": "dress"
                },
                {
                    "title": "old man"
                },
                {
                    "title": "yogi"
                },
                {
                    "title": "painted face"
                },
                {
                    "title": "gray hair"
                }
            ],
            "photo_tags": [
                {
                    "title": "man"
                },
                {
                    "title": "male"
                },
                {
                    "title": "elderly"
                },
                {
                    "title": "old"
                },
                {
                    "title": "face"
                }
            ]
        }]}
        """
        let responseData = response.data(using: .utf8)!
        
        return responseData
    }
}
