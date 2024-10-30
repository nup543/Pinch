//
//  NetworkLayer.swift
//  KLMAssignment
//
//  Created by Nupur Sharma on 10/03/2022.
//

import UIKit
import Combine


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
                    return HTTPNetworkError.decodingFailed
                case _ as URLError:
                    return HTTPNetworkError.badRequest
                case URLError.notConnectedToInternet:
                    return HTTPNetworkError.userIsOffline
                default:
                    return HTTPNetworkError.noData
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
