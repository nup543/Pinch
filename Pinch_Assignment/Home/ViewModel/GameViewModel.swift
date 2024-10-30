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

@Observable class GameViewModel {
    
    static var shared = GameViewModel()
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
    
    
    init() {
        
    }
    
    @MainActor
    func fetchData(modelContext: ModelContext) async throws {
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
            }, receiveValue: { result in
                DispatchQueue.main.async {
                    result.forEach { modelContext.insert($0) }
                    do {
                        try modelContext.save()
                    }
                    catch {
                        
                    }
                }
                
            })
            .store(in: &GameViewModel.shared.cancellables)
    }
    
    func getCoverImgURL(for id: String?, imageSize: ImageSize = .small) -> String {
        switch imageSize {
        case .big:
            return "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id ?? "").jpg"
        default :
            return  "https://images.igdb.com/igdb/image/upload/t_cover_small/\(id ?? "").jpg"
        }
    }
    
    func fetchData1()  async throws {
        var request = gamesRequest
        request?.httpBody = Keys.gamesQuery.data(using: .utf8)
        URLSession.shared.dataTask(with: request!) { data, response, error in
               guard let data else {
                  
                   return
               }
               guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                  
                   return
               }
               do {
                   let products = try JSONDecoder().decode([Item].self, from: data)
                  
               }
               catch (let error) {
                   print("\(error)")
                   
               }
           }.resume()
       }
    
    func getGames() -> AnyPublisher<[Item], Error>? {
        var request = gamesRequest
        request?.setValue(Keys.access_token, forHTTPHeaderField: "Authorization")
        request?.httpBody = Keys.gamesQuery.data(using: .utf8)
        
        return NetworkLayer().networkPublisher(request: request)
    }
}

struct Keys {
    static let clientSecret = "73xvnx90dczwjnrsavopfjh6vbimxf"
    static let clientId = "jq8f4najhrmzod83tp00y6h3clowf4"
    static let access_token = "Bearer j7265djys4ujt9w76uz5cr6cj9jrz6" // it expires in > 50 days
    static let gamesQuery = "fields name, url, created_at, summary, cover.image_id;"
    static let gameBaseUrl = "https://api.igdb.com/v4/games"
    static let tokenKey = "token"
    static let expirationKey = "expirationTime"
    
}
