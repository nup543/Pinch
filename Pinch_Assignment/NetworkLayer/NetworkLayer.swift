//
//  NetworkLayer.swift
//  KLMAssignment
//
//  Created by Nupur Sharma on 10/03/2022.
//

import UIKit
import Combine

public enum HTTPNetworkError: Error {
    case badRequest
    case decodingFailed
    case userIsOffline
    case noData
    
}
struct NetworkLayer {
 
    func networkPublisher<T: Codable>(request: URLRequest?) -> AnyPublisher<T,Error>? {
        
        guard let request = request else {return nil}

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw HTTPNetworkError.badRequest}
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return Fail<Any, HTTPNetworkError>(error: HTTPNetworkError.decodingFailed) as! Error//HTTPNetworkError.decodingFailed
                case _ as URLError:
                    return Fail<Any, HTTPNetworkError>(error: HTTPNetworkError.badRequest) as! Error//HTTPNetworkError.badRequest
                case URLError.notConnectedToInternet:
                    return Fail<Any, HTTPNetworkError>(error: HTTPNetworkError.userIsOffline) as! Error//HTTPNetworkError.userIsOffline
                default:
                    return Fail<Any, HTTPNetworkError>(error: HTTPNetworkError.noData) as! Error//HTTPNetworkError.noData
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
