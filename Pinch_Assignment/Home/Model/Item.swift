//  Item.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import Foundation
import SwiftData

@Model final class Item: Codable, Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var summary: String?
    var websiteURL: String
    var createdAt: Double?
    @Relationship(deleteRule: .cascade) var cover: Cover?
    
    init(name: String, id: Int, summary: String,websiteURL: String, createdAt: Double, cover: Cover?) {
        self.name = name
        self.id = id
        self.cover = cover
        self.summary = summary
        self.websiteURL = websiteURL
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case name, id, cover, summary
        case websiteURL = "url"
        case createdAt = "created_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        websiteURL = try container.decode(String.self, forKey: .websiteURL)
        createdAt = try container.decodeIfPresent(Double.self, forKey: .createdAt)
        cover = try container.decodeIfPresent(Cover.self, forKey: .cover)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encode(websiteURL, forKey: .websiteURL)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(cover, forKey: .cover)
    }
}

extension Item {
    static func example() -> Item {
        let item = Item(name: "Zoomanji", id: 1, summary: "Shoot bubbles and match colors to pop your way up to victory in this bubble shooting adventure, win magic keys to unlock more secret colorful bubble world, it’s time to enjoy the endless bubble shooting fun!", websiteURL: "https://www.igdb.com/games/bubble-whirl-shooter", createdAt: 1521138594, cover: Cover(id: 1, imageId: "co7anz"))
        return item
    }
}
