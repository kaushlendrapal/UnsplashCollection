
import Foundation

struct Links : Codable {
	let html : String?
	let photos : String?
	let likes : String?
	let portfolio : String?
	let following : String?
	let followers : String?

	enum CodingKeys: String, CodingKey {

		case html = "html"
		case photos = "photos"
		case likes = "likes"
		case portfolio = "portfolio"
		case following = "following"
		case followers = "followers"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		html = try values.decodeIfPresent(String.self, forKey: .html)
		photos = try values.decodeIfPresent(String.self, forKey: .photos)
		likes = try values.decodeIfPresent(String.self, forKey: .likes)
		portfolio = try values.decodeIfPresent(String.self, forKey: .portfolio)
		following = try values.decodeIfPresent(String.self, forKey: .following)
		followers = try values.decodeIfPresent(String.self, forKey: .followers)
	}

}
