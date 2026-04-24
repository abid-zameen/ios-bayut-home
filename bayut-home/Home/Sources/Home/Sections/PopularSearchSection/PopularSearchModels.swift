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
    case offplan = "Off-Plan"
}

public struct PopularSearchCategory: Hashable {
    public let id: String
    public let title: String
    public let iconName: String
    
    public init(id: String, title: String, iconName: String) {
        self.id = id
        self.title = title
        self.iconName = iconName
    }
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
    public let categories: [PopularSearchCategory]
    
    public init(purpose: PopularSearchPurpose, categories: [PopularSearchCategory]) {
        self.purpose = purpose
        self.categories = categories
    }
}

// MARK: - ElasticSearch Popular Section Models
public struct PopularSectionResponse: Decodable {
    public let responses: [PopularSectionItem]?
    
    public init(responses: [PopularSectionItem]?) {
        self.responses = responses
    }
}

public struct PopularSectionItem: Decodable {
    public let aggregations: PopularGroupAggregations?
}

public struct PopularGroupAggregations: Decodable {
    public let group: PopularGroup?
}

public struct PopularGroup: Decodable {
    public let buckets: [PopularBucket]?
}

public struct PopularBucket: Decodable {
    public let key: String?
    public let sum: PopularSum?
    
    enum CodingKeys: String, CodingKey {
        case key, sum
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intKey = try? container.decode(Int.self, forKey: .key) {
            key = String(intKey)
        } else {
            key = try container.decodeIfPresent(String.self, forKey: .key)
        }
        sum = try container.decodeIfPresent(PopularSum.self, forKey: .sum)
    }
}

public struct PopularSum: Decodable {
    public let value: Double?
}
