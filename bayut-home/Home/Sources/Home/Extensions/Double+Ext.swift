//
//  Double+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//

import Foundation

extension Double {
    func convertToDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
