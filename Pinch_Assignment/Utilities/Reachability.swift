//
//  Reachability.swift
//  KLMAssignment
//
//  Created by Nupur Sharma on 10/03/2022.
//

import Foundation
import Network
import Combine
enum NetworkStatus: String {
    case connected
    case disconnected
}

@Observable class Reachability {
  let monitor = NWPathMonitor()
  let queue = DispatchQueue.global(qos: .background)
 var connected: NetworkStatus = .connected
   
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.connected = .connected
                    
                } else {
                    print("No connection.")
                    self.connected = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    
}
