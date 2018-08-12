
import Foundation
import UIKit

struct USImage : Decodable {
    
    let id : String?
    let createdAt : String?
    let updatedAt : String?
    let width : Int?
    let height : Int?
    let color : String?
    let description : String?
    let urls : Urls?
    let links : Links?
    let categories : [String]?
    let sponsored : Bool?
    let likes : Int?
    let liked_by_user : Bool?
    let current_user_collections : [String]?
    let slug : String?
    let user : User?
    let tags : [Tags]?
    let photoTags : [PhotoTags]?
    var image: UIImage
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case description = "description"
        case urls = "urls"
        case links = "links"
        case categories = "categories"
        case sponsored = "sponsored"
        case likes = "likes"
        case liked_by_user = "liked_by_user"
        case current_user_collections = "current_user_collections"
        case slug = "slug"
        case user = "user"
        case tags = "tags"
        case photo_tags = "photo_tags"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .created_at)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updated_at)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        urls = try values.decodeIfPresent(Urls.self, forKey: .urls)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
        sponsored = try values.decodeIfPresent(Bool.self, forKey: .sponsored)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        liked_by_user = try values.decodeIfPresent(Bool.self, forKey: .liked_by_user)
        current_user_collections = try values.decodeIfPresent([String].self, forKey: .current_user_collections)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        tags = try values.decodeIfPresent([Tags].self, forKey: .tags)
        photoTags = try values.decodeIfPresent([PhotoTags].self, forKey: .photo_tags)
        image = UIImage(named: "Placeholder")!
    }
    
}
