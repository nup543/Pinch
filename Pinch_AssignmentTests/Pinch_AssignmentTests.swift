//
//  Pinch_AssignmentTests.swift
//  Pinch_AssignmentTests
//
//  Created by Nupur Sharma on 25/10/24.
//

import Testing
import SwiftData
@testable import Pinch_Assignment

struct Pinch_AssignmentTests {
   
    @MainActor
    @Test func saveToDB() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Cover.self, configurations: config)
        let context = container.mainContext
        let sut =  MockViewModel(modelContext: context)
        try context.delete(model: Cover.self)
        sut.saveGamesLocally(data: dummyGames, modelContext: context)
        let fetchCount = try sut.fetchData().count
        #expect(fetchCount == 2)
    }
    
    var dummyGames: [Cover] {
        var list =  [Cover.example()]
        list.append(Cover(id: 4, imageId: "co448a"))
        return list
    }

}
