//
//  Item.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 25/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
