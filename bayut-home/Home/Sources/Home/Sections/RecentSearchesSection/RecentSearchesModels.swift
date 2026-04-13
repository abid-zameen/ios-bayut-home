//
//  RecentSearchesModels.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

public struct HomeScreenRecentSearch {
    public let id: String
    public let createdAt: Date?
    public let title: String
    public let subtitle: String
    public let imageURL: String?
    public let filters: [HomeScreenRecentSearchFilter]
    public let locations: [String]
    
    public init(id: String, createdAt: Date?, title: String, subtitle: String, imageURL: String?, filters: [HomeScreenRecentSearchFilter], locations: [String]) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.filters = filters
        self.locations = locations
    }
}

public struct HomeScreenRecentSearchFilter {
    public let type: HomeScreenRecentSearchFilterType
    public let value: String
    
    public init(type: HomeScreenRecentSearchFilterType, value: String) {
        self.type = type
        self.value = value
    }
}

public enum HomeScreenRecentSearchFilterType: String, CaseIterable {
    case beds = "Beds"
    case price = "Price"
    case furnished = "Furnished"
    case truCheck = "TruCheck"
    case other = "Other"
    
    public var priority: Int {
        switch self {
        case .beds: return 1
        case .price: return 2
        case .furnished: return 3
        case .truCheck: return 4
        case .other: return 5
        }
    }
}
