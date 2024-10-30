//  APIClient.swift
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

@Observable class APIClient {
    
    static var shared = APIClient()
    var errorMessage: String?
    let shooterGameBaseUrl2 = "https://id.twitch.tv/oauth2/token?client_id=\(Keys.clientId)&client_secret=\(Keys.clientSecret)&grant_type=client_credentials"
    let shooterGameBaseUrl = "https://api.igdb.com/v4/games"
    let gameDetailBaseUrl = "https://www.mmobomb.com/api1/game?id="
    
     var cancellables = Set<AnyCancellable>()
    
     var gamesRequest : URLRequest? {
        guard let serviceUrl = URL(string: shooterGameBaseUrl) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Keys.clientId, forHTTPHeaderField: "Client-ID")
        request.setValue(Keys.access_token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    init() {
        
    }
    
    @MainActor
    func fetchData(modelContext: ModelContext) async throws {
        getShooterGames()?
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let err = error as? HTTPNetworkError {
                        switch err {
                        case HTTPNetworkError.noData:
                            self.errorMessage = "No data found"
                        default:
                            self.errorMessage = "Something went wrong!"
                        }
                    }
                }
            }, receiveValue: { resultShooter in
               // guard let self = self else { return  }
                DispatchQueue.main.async {
                    resultShooter.forEach { modelContext.insert($0) }
                    do {
                        try modelContext.save()
                    }
                    catch {
                        
                    }
                }
//                do {
//                    let descriptor = FetchDescriptor<Item>()
//                    let val = try modelContext.fetch(descriptor)
//                    let existingUsers = try modelContext.fetchCount(descriptor)
//                    print("existingUsers222 \(existingUsers)")
//                    
//                } catch {
//                    
//                }
                
            })
            .store(in: &APIClient.shared.cancellables)
    }
    
    func getCoverImgURL(for id: String?, imageSize: ImageSize = .small) -> String {
        switch imageSize {
        case .big:
            return "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id ?? "").jpg"
        default :
            return  "https://images.igdb.com/igdb/image/upload/t_cover_small/\(id ?? "").jpg"
        }
    }
    
    func fetchDataDetail(id: String) async throws {
        getShooterGameDetail(id: id)?
            .sink(receiveCompletion: { completion in
              switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let err = error as? HTTPNetworkError {
                        switch err {
                        case HTTPNetworkError.noData:
                            self.errorMessage = "No data found"
                        default:
                            self.errorMessage = "Something went wrong!"
                        }
                    }
                }
            }, receiveValue: { resultShooter in
               // guard let self = self else { return  }
               
            })
            .store(in: &APIClient.shared.cancellables)
    }
    
//    func fetchData1(id: String) -> Void {
//       
//       // Keys.gameImageId = "\(id)"
//        var request = gamesRequest
//        //request?.httpBody = Keys.gameDetailQuery.data(using: .utf8)
//        URLSession.shared.dataTask(with: request!) { data, response, error in
//               guard let data else {
//                  
//                   return
//               }
//               guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
//                  
//                   return
//               }
//                // JSONDecoder() converts data to model of type Array
//               do {
//                   let products = try JSONDecoder().decode([Item].self, from: data)
//                  
//               }
//               catch (let error) {
//                   print("\(error)")
//                   
//               }
//           }.resume()
//       }
    
    func getShooterGames() -> AnyPublisher<[Item], Error>? {
        var request = gamesRequest
        request?.httpBody = Keys.gamesQuery.data(using: .utf8)
        return NetworkLayer().networkPublisher(request: request)
    }
    
    func getShooterGameDetail(id: String) -> AnyPublisher<Item, Error>? {
        var request = gamesRequest
        request?.httpBody = Keys.gamesQuery.data(using: .utf8)
        return NetworkLayer().networkPublisher(request: request)
    }

}

struct Keys {
    static let clientSecret = "73xvnx90dczwjnrsavopfjh6vbimxf"
    static let clientId = "jq8f4najhrmzod83tp00y6h3clowf4"
    static let access_token = "Bearer j7265djys4ujt9w76uz5cr6cj9jrz6"
    static let gamesQuery = "fields name, cover.image_id;"
    
}
