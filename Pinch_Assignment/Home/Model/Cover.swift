//
//  Cover.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//
import Foundation
import SwiftData

@Model final class Cover: Codable {
    @Attribute(.unique) var id: Int?
    var imageId: String?
    
    init(id: Int, imageId: String) {
        self.id = id
        self.imageId = imageId
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageId = "image_id"
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        imageId = try values.decode(String.self, forKey: .imageId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageId, forKey: .imageId)
    }
}

extension Cover {
    static func example() -> Cover {
        let item = Cover(id: 1, imageId: "co7anz")
        return item
    }
}
