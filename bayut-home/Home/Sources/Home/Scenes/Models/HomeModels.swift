//
//  HomeModels.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

struct Home {
    struct HomeViewModel {
        let sections: [AnySection]
        let animated: Bool
    }
    
    struct HomeSections {
        let projects: [NewProject]
        let locations: [LocationChipViewModel]
        let favourites: [Property]
        let savedSearches: [SavedSearchesModel]
        let blogs: [Blog]
        let nearbyLocations: [NearbyLocation]
        let isLocationEnabled: Bool
        let popularSearches: [PopularSearch]
        let popularSearchConfig: PopularSearchConfig?
        let purposes: [PopularSearchPurpose]
        let selectedPurpose: PopularSearchPurpose
        let recentSearches: [HomeScreenRecentSearch]
        let viewController: HomeViewController
    }
    
    struct Response {
        let projects: [NewProject]
        let locations: [LocationChipViewModel]
        let favourites: [Property]
        let savedSearches: SavedSearchesData?
        let blogs: [Blog]
        let nearbyLocations: [Location]
        let isLocationEnabled: Bool
        let popularSearches: [PopularSearch]
        let popularSearchConfig: PopularSearchConfig?
        let purposes: [PopularSearchPurpose]
        let selectedPurpose: PopularSearchPurpose
        let recentSearches: [HomeScreenRecentSearch]
    }
}

struct SavedSearchesData {
    let searches: [SavedSearch]
    let resolvedLocations: [Location]
}

struct FavoriteIDItem: Codable {
    let adExternalID: String?
}

typealias FavoritesIDsResponse = [FavoriteIDItem]

struct AlgoliaPropertyHit: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let rooms: Int?
    let baths: Int?
    let area: Double?
    let location: [Location]?
    let coverPhoto: CoverPhoto?
    let purpose: Purpose?
    let rentFrequency: String?
    let externalID: String?
    let completionDetails: CompletionDetails?
    let paymentPlans: [PaymentPlan]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case rooms
        case baths
        case area
        case location
        case coverPhoto
        case purpose
        case rentFrequency
        case externalID
        case completionDetails
        case paymentPlans = "paymentPlanSummaries"
    }
}

struct CompletionDetails: Codable {
    let completionDateInt: Double?
    let completionPercentage: Double?
    
    enum CodingKeys: String, CodingKey {
        case completionDateInt = "completionDate"
        case completionPercentage
    }
}

struct PaymentPlan: Codable {
    let preHandoverSum: Double?
    let postHandoverSum: Double?
    let preHandOverPercentageSum: Double?
    let postHandOverPercentageSum: Double?
}

struct CoverPhoto: Codable {
    let id: Int?
    let externalID: String?
    let title: String?
}

enum Purpose: String, Codable {
    case rent = "for-rent", buy = "for-sale"
}

struct Location: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let level: Int?
    let cityName: String?
    let geography: Geography?
    let adCount: Int?
}

struct Geography: Codable {
    let lat: Double
    let lng: Double
}

// MARK: - API Response Models
struct SavedSearch: Codable {
    let id: Int
    let name: String
    let params: SavedSearchInfo
}

struct SavedSearchInfo: Codable {
    let category: String
    let locations: [String]?
    let purpose: String
}
