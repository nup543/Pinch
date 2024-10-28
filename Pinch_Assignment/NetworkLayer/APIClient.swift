//  APIClient.swift
//  KLMAssignment
//  Created by Nupur Sharma on 10/03/2022.

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable class APIClient {
    
    static var shared = APIClient()
    var errorMessage: String?
  //  @Environment(\.modelContext) private var modelContext
    public let container: ModelContainer = {
           let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: Item.self, configurations: config)
           return container
       }()
       
       public var context: ModelContext
    
    let shooterGameBaseUrl2 = "https://id.twitch.tv/oauth2/token?client_id=\(Keys.clientId)&client_secret=\(Keys.clientSecret)&grant_type=client_credentials"
    let shooterGameBaseUrl = "https://api.igdb.com/v4/games"
    let gameDetailBaseUrl = "https://www.mmobomb.com/api1/game?id="
    
    private var cancellables = Set<AnyCancellable>()
    
    private var gamesRequest : URLRequest? {
        guard let serviceUrl = URL(string: shooterGameBaseUrl) else { return nil }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Keys.clientId, forHTTPHeaderField: "Client-ID")
        request.setValue(Keys.access_token, forHTTPHeaderField: "Authorization")
        request.httpBody = Keys.gamesQuery.data(using: .utf8)
        return request
    }
    
    init() {
        self.context = ModelContext(container)
    }
   
//    @MainActor
//      func updateDataInDatabase(modelContext: ModelContext) async {
//          do {
//              let itemData: [Item] = try await fetchData()
//              for eachItem in itemData {
//                  let itemToStore = Item()
//                 // modelContext.insert(itemToStore)
//              }
//          } catch {
//              print("Error fetching data")
//              print(error.localizedDescription)
//          }
//      }
    
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
                resultShooter.forEach { modelContext.insert($0) }
            })
            .store(in: &APIClient.shared.cancellables)
    }
    
    func fetchData1(completion: @escaping (Result<[Item], Error>) -> Void) {
            let Url = String(format: shooterGameBaseUrl)
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(Keys.clientId, forHTTPHeaderField: "Client-ID")
            request.setValue(Keys.access_token, forHTTPHeaderField: "Authorization")
            request.httpBody = Keys.gamesQuery.data(using: .utf8)
            //fields *; where id = 1942;
            
            URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data else {
                   completion(.failure(HTTPNetworkError.badRequest))
                   return
               }
               guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                   completion(.failure(HTTPNetworkError.badRequest))
                   return
               }
                // JSONDecoder() converts data to model of type Array
               do {
                   let products = try JSONDecoder().decode([Item].self, from: data)
                   completion(.success(products))
               }
               catch (let error) {
                   print("\(error)")
                   completion(.failure(HTTPNetworkError.badRequest))
               }
           }.resume()
       }
    
    func getShooterGames() -> AnyPublisher<[Item], Error>? {
        NetworkLayer().networkPublisher(request: gamesRequest)
    }
    
//    func getShooterGameDetail(id: Int) -> AnyPublisher<Item, Error>? {
//        return NetworkLayer().networkPublisher(urlString: gameDetailBaseUrl + "\(id)")
//    }
    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

enum Keys {
    static let clientSecret = "73xvnx90dczwjnrsavopfjh6vbimxf"
    static let clientId = "jq8f4najhrmzod83tp00y6h3clowf4"
    static let access_token = "Bearer j7265djys4ujt9w76uz5cr6cj9jrz6"
    static let gamesQuery = "fields name, cover.*;"
    static var gameId: String?
    static var gameDetailQuery: String {
        "fields *; where id = \(gameId ?? "");"
    }
}
