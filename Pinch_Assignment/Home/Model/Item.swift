//  Item.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import Foundation
import SwiftData

@Model final class Item: Codable, Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    @Relationship(deleteRule: .cascade) var cover: Cover?
    
    init(name: String, id: Int, cover: Cover?) {
        self.name = name
        self.id = id
        self.cover = cover
    }
    
    enum CodingKeys: CodingKey {
        case name
        case id
        case cover
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        cover = try container.decodeIfPresent(Cover.self, forKey: .cover)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(cover, forKey: .cover)
    }
}

extension Item {
    static func example() -> Item {
        let item = Item(name: "Zoomanji", id: 1, cover: Cover(id: 1, imageId: "co7anz"))
        return item
    }
}
