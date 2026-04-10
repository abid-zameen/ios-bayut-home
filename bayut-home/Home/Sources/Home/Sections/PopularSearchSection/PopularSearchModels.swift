//
//  PopularSearchModels.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import Foundation

public enum PopularSearchPurpose: String, CaseIterable {
    case buy = "Buy"
    case rent = "Rent"
    case dailyRental = "Daily Rental"
}

struct PopularSearch: Hashable {
    let title: String
    let location: String
    let iconName: String
}

public struct PopularSearchConfig {
    public let purposeConfigs: [PopularSearchPurposeConfig]
    
    public init(purposeConfigs: [PopularSearchPurposeConfig]) {
        self.purposeConfigs = purposeConfigs
    }
}

public struct PopularSearchPurposeConfig {
    public let purpose: PopularSearchPurpose
    public let categories: [String] // Array of slugs
    
    public init(purpose: PopularSearchPurpose, categories: [String]) {
        self.purpose = purpose
        self.categories = categories
    }
}
