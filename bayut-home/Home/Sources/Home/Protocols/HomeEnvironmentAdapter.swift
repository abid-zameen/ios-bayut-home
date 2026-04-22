import Foundation

// MARK: - Home Environment Adapter
/// Protocol defining the environment constants required by the Home module
public protocol HomeEnvironmentAdapter {
    var baseURL: String { get }
    var imageBaseUrl: String { get }
    var algoliaAppID: String { get }
    var algoliaAPIKey: String { get }
    var userID: String? { get }
    var blogAuthorization: String { get }
    var blogAuthorizationHeaderKey: String { get }
    var isProductTypeEnabled: Bool { get }
    var isTuBrokerEnabled: Bool { get }
    var shouldShowDOTWChip: Bool { get }
    var isProjectWhatsAppEnabledHome: Bool { get }
    var storiesViewHeight: CGFloat { get }
    
    // MARK: - Location
    var userCoordinates: (lat: Double, lon: Double)? { get }
    var isLocationAuthorized: Bool { get }
    func requestLocationAuthorization()
    
    // MARK: - Recent Searches
    var recentSearchesProvider: RecentSearchesProvider { get }
}
