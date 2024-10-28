//  Item.swift
//  Pinch_Assignment
//  Created by Nupur Sharma on 25/10/24.

import Foundation
import SwiftData

@Model final class Item: Codable, Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var cover: Cover?
    
    init() {
        self.name = ""
        self.id = 0
        self.cover = nil
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

@Model class Cover: Codable {
    @Attribute(.unique) var id: Int?
    var url: String?
    
    init() {
        self.id = nil
        self.url = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        url = try values.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
    }
}
