//
//  HomePurpose.swift
//  Home
//
//  Created by Hammad Shahid on 14/04/2026.
//

import Foundation

public enum HomePurpose: String, CaseIterable {
    case buy
    case rent
    
    public var title: String {
        switch self {
        case .buy: return "buy".localized()
        case .rent: return "rent".localized()
        }
    }
}
