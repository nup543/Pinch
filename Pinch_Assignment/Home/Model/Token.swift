//
//  Token.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//

class Token: Codable {
    var token: String
    var expirationTime: Double
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case expirationTime = "expires_in"
        case type = "token_type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        expirationTime = try container.decode(Double.self, forKey: .expirationTime)
        type = try container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(expirationTime, forKey: .expirationTime)
        try container.encode(type, forKey: .type)
    }
}
