//
//  GameProviderProtocol.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 31/10/24.
//
import SwiftData

public protocol GameProviderProtocol {
    init(modelContext: ModelContext)
    func saveGamesLocally<T: PersistentModel>(data: [T], modelContext: ModelContext?)
}

public enum HTTPNetworkError: Error {
    case badRequest
    case decodingFailed
    case userIsOffline
    case noData
}
extension GameProviderProtocol {
    func saveGamesLocally<T: PersistentModel> (data: [T], modelContext: ModelContext?)  {
        data.forEach { modelContext?.insert($0) }
        do {
            try modelContext?.save()
        }
        catch {
            print("db save failure")
        }
    }
}
