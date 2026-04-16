import UIKit

public protocol HomeNavigationAdapter {
    func navigateToLocationSearch(from viewController: UIViewController?, purpose: HomePurpose)
    func navigateToLocationForProjects(from viewController: UIViewController?)
    func navigateToDubaiTransaction(from viewController: UIViewController?)
    func navigateToFindAgents(from viewController: UIViewController?)
    func navigateToBlogs(url: String, title: String?, from viewController: UIViewController?)
    func navigateToLocationForTransactions(from viewController: UIViewController?, purpose: HomePurpose)
    func naviagteToAllBlogs(from viewController: UIViewController?)
    func navigateToNearbySearch(location: LocationHit, from viewController: UIViewController?)
    func navigateToSavedSearch(savedSearchData: [String: Any], resolvedLocations: [LocationHit], from viewController: UIViewController?)
    func navigateToAllFavorites(from viewController: UIViewController?)
    func navigateToAllSavedSearches(from viewController: UIViewController?)
    func navigateToPropertyDetail(with externalId: String, from viewController: UIViewController?)
}
