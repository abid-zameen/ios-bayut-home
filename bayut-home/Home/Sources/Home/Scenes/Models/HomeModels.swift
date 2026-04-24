//
//  HomeModels.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

struct Home {
    enum DataState<T> {
        case loading
        case data(T)
        case empty
        
        var value: T? {
            switch self {
            case .data(let value): return value
            default: return nil
            }
        }
    }

    struct HomeViewModel {
        let sections: [AnySection]
        let animated: Bool
    }
    
    struct HomeSections {
        let projects: DataState<[ProjectHit]>
        let locations: [LocationChipViewModel]
        let favourites: DataState<[Property]>
        let savedSearches: DataState<[SavedSearchesModel]>
        let blogs: DataState<[Blog]>
        let nearbyLocations: DataState<[LocationHit]>
        let isLocationEnabled: Bool
        let popularSearches: DataState<[PopularSearch]>
        let popularSearchConfig: PopularSearchConfig?
        let selectedLocation: String
        let purposes: [PopularSearchPurpose]
        let selectedPurpose: PopularSearchPurpose
        let recentSearches: DataState<[HomeScreenRecentSearch]>
        let showTruBrokerBanner: Bool
        let showSellerLeadsBanner: Bool
        let marketingBannerConfig: MarketingBannerConfig?
        let viewController: HomeViewController
    }
    
    struct Response {
        var projects: DataState<[ProjectHit]> = .loading
        var locations: [LocationChipViewModel] = []
        var selectedNewProjectsLocationID: String = ""
        var favourites: DataState<[Property]> = .loading
        var savedSearches: DataState<SavedSearchesData> = .loading
        var blogs: DataState<[Blog]> = .loading
        var nearbyLocations: DataState<[LocationHit]> = .loading
        var isLocationEnabled: Bool = false
        var popularSearchState: DataState<PopularSearchConfig> = .loading
        var purposes: [PopularSearchPurpose] = []
        var selectedPurpose: PopularSearchPurpose = .rent
        var recentSearches: DataState<[HomeScreenRecentSearch]> = .loading
        var showTruBrokerBanner: Bool = true
        var showSellerLeadsBanner: Bool = false
        var marketingBannerConfig: MarketingBannerConfig? = nil
    }
}

struct SavedSearchesData {
    let searches: [SavedSearch]
    let resolvedLocations: [LocationHit]
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
    let location: [LocationHit]?
    let coverPhoto: CoverPhoto?
    let purpose: Purpose?
    let rentFrequency: String?
    let externalID: String?
    let completionDetails: CompletionDetails?
    let paymentPlans: [PaymentPlan]?
    let isVerified: Bool
    let verification: Verification?
    let completionStatus: String?
    let offplanDetails: OffplanDetails?
    let ownerAgent: OwnerAgent?
    
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
        case isVerified
        case verification
        case completionStatus
        case offplanDetails
        case ownerAgent
    }
}

struct OwnerAgent: Codable, Hashable {
    let externalID: String?
    let name: String?
    let userImage: String?
    let isTruBroker: Bool?
    
    enum CodingKeys: String, CodingKey {
        case externalID
        case name
        case userImage = "user_image"
        case isTruBroker
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

struct Verification: Codable {
    let eligible: Bool
}

struct OffplanDetails: Codable, Hashable {
    let saleType: String
}

struct PaymentPlan: Codable {
    let preHandoverPercentageSum: Double?
    let postHandoverPercentageSum: Double?
}

struct CoverPhoto: Codable {
    let id: Int?
    let externalID: String?
    let title: String?
}

enum Purpose: String, Codable {
    case rent = "for-rent", buy = "for-sale"
}

public struct LocationHit: Codable {
    public let id: Int?
    public let name: String?
    public let name_l1: String?
    public let name_l2: String?
    public let name_l3: String?
    public let slug: String?
    public let level: Int?
    public let cityName: String?
    public let geography: Geography?
    public let adCount: Int?
    public let externalID: String?
    public let hierarchy: [LocationHierarchy]?

    public var localizedName: String {
        let lang = HomeModule.shared.environment.appLanguage
        switch lang {
        case "ar": return name_l1 ?? name ?? ""
        case "zh": return name_l2 ?? name ?? ""
        case "ru": return name_l3 ?? name ?? ""
        default: return name ?? ""
        }
    }
}

public struct LocationHierarchy: Codable {
    public let externalID: String?
    public let id: Int?
    public let level: Int?
    public let name: String?
    public let name_l1: String?
    public let name_l2: String?
    public let name_l3: String?
    public let slug: String?
    public let slug_l1: String?
    public let slug_l2: String?
    public let slug_l3: String?
    
    public var localizedName: String {
        let lang = HomeModule.shared.environment.appLanguage
        switch lang {
        case "ar": return name_l1 ?? name ?? ""
        case "zh": return name_l2 ?? name ?? ""
        case "ru": return name_l3 ?? name ?? ""
        default: return name ?? ""
        }
    }
}

public struct Geography: Codable {
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
    let categories: [String]?
    let locations: [String]?
    let purpose: String?
    let baths: [Int]?
    let beds: [Int]?
    let price: SavedSearchRange?
    let area: SavedSearchRange?
    let videoCount: SavedSearchRange?
    let hasFloorPlan: SavedSearchRange?
    let rentFrequency: String?
    let keywords: [String]?
    let completionStatus: String?
    let agencies: [String]?
}

struct SavedSearchRange: Codable {
    let min: Double?
    let max: Double?
}
