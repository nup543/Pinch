//
//  Preview.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//

import Foundation
import SwiftData

struct Preview {
    
    let modelContainer: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: Item.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    func addExamples(_ examples: [Item]) {
           
           Task { @MainActor in
               examples.forEach { example in
                   modelContainer.mainContext.insert(example)
               }
           }
           
       }
    
}
