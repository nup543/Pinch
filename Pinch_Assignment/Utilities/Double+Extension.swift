//
//  Double+Extension.swift
//  Pinch_Assignment
//
//  Created by Nupur Sharma on 30/10/24.
//
import Foundation

extension Double {
    func getDateStringFromUnixTime() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd YYYY"
        return dateFormatter.string(from: date)
    }
}
