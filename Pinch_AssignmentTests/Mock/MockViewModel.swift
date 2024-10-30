//
//  MockViewModel.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 31/10/24.
//
import SwiftData

class MockViewModel: GameProviderProtocol {
    var modelContext: ModelContext!
    private(set) var games = [Cover]()
    
    required init(modelContext: ModelContext) {
        self.modelContext = modelContext
       
    }
    
    func fetchData() throws -> [Cover] {
        do {
            let descriptor = FetchDescriptor<Cover>()
            let items = try modelContext.fetch(descriptor)
            return items
        } catch {
            throw HTTPNetworkError.noData
        }
    }
    
}
