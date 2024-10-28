//
//  ReuseIdentifying.swift
//  KLMAssignment
//
//  Created by Nupur Sharma on 10/03/2022.
//

import Foundation
protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}
extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
