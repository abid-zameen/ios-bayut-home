import Foundation

// MARK: - Home Environment Adapter
/// Protocol defining the environment constants required by the Home module
public protocol HomeEnvironmentAdapter {
    var baseURL: String { get }
    var algoliaProjectIndex: String { get }
    var algoliaLocationIndex: String { get }
    var algoliaListingIndex: String { get }
    var selectedCurrency: String { get }
    var dldBaseUrl: String { get }
    var imageBaseUrl: String { get }
    var userID: String? { get }
    var blogAuthorization: String { get }
    var blogAuthorizationHeaderKey: String { get }
    var isProductTypeEnabled: Bool { get }
    var isTuBrokerEnabled: Bool { get }
    var shouldShowDOTWChip: Bool { get }
    var isProjectWhatsAppEnabledHome: Bool { get }
    var storiesViewHeight: CGFloat { get }
    var shouldFetchPopularSectionViaElasticSearch: Bool { get }
    var isSellerLeadsEnabled: Bool { get }
    var isRailingAutoScrollEnabled: Bool { get }
    var recentSearchesProvider: RecentSearchesProvider { get }
    var marketingBannerConfig: MarketingBannerConfig? { get }
    var isAppOnboardingEnabled: Bool { get }
    var isOnboardingV2Enabled: Bool { get }
    var wasDeepLinkInitiated: Bool { get }
    var hasDisplayedOnboarding: Bool { get }
    var isOnboardingInProgress: Bool { get set }
    func setOnboardingDisplayed()
    var truEstimateVariant: String { get }
    var shouldShowAppReview: Bool { get }
    var isFavouritesWithoutLoginEnabled: Bool { get }
    var unsyncedFavouriteIDs: [String] { get }
    func toggleLocalFavorite(externalID: String)
    func syncFavourites() async
    var viewedListingIDs: [String] { get }
    var contactedListingIDs: [String] { get }
}
