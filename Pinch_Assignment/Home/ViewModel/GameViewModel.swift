//  GameViewModel.swift
//  KLMAssignment
//  Created by Nupur Sharma on 10/03/2022.

import Foundation
import Combine
import SwiftData
import SwiftUI

enum ImageSize {
    case small
    case big
}

@Observable class GameViewModel: GameProviderProtocol {
    
    var modelContext: ModelContext!
    let accessTokenUrl = "https://id.twitch.tv/oauth2/token?client_id=\(Keys.clientId)&client_secret=\(Keys.clientSecret)&grant_type=client_credentials"
    var cancellables = Set<AnyCancellable>()
    
     var gamesRequest : URLRequest? {
        guard let serviceUrl = URL(string: Keys.gameBaseUrl) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Keys.clientId, forHTTPHeaderField: "Client-ID")
        return request
    }
    
    
    required init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func fetchData() async throws {
        getGames()?
            .sink(receiveCompletion: { completion in
              switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let err = error as? HTTPNetworkError {
                        switch err {
                        case HTTPNetworkError.noData:
                            print("No data found")
                        default:
                            print("Something went wrong!")
                        }
                    }
                }
            }, receiveValue: { [weak self] result in
                DispatchQueue.main.async {
                    self?.saveGamesLocally(data: result, modelContext: self?.modelContext)
                }
            })
            .store(in: &cancellables)
    }

    
    func getCoverImgURL(for id: String?, imageSize: ImageSize = .small) -> String {
        switch imageSize {
        case .big:
            return "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id ?? "").jpg"
        default :
            return  "https://images.igdb.com/igdb/image/upload/t_cover_small/\(id ?? "").jpg"
        }
    }
    
    func getGames() -> AnyPublisher<[Item], Error>? {
        var request = gamesRequest
        request?.setValue(Keys.access_token, forHTTPHeaderField: "Authorization")
        request?.httpBody = Keys.gamesQuery.data(using: .utf8)
        
        return NetworkLayer().networkPublisher(request: request)
    }
}

enum Keys {
    static let clientSecret = "73xvnx90dczwjnrsavopfjh6vbimxf"
    static let clientId = "jq8f4najhrmzod83tp00y6h3clowf4"
    static let access_token = "Bearer j7265djys4ujt9w76uz5cr6cj9jrz6" // it expires in > 50 days
    static let gamesQuery = "fields name, url, created_at, summary, cover.image_id;"
    static let gameBaseUrl = "https://api.igdb.com/v4/games"
}
