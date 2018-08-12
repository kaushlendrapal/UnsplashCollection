
import Foundation

struct Tags : Codable {
	let title : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}

}
