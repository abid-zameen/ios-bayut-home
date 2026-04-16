import UIKit

protocol HomeRoutingLogic: AnyObject {
    func routeToLocationSearch(purpose: HomePurpose)
    func routeToLocationForProjects()
    func routeToDubaiTransaction()
    func routeToFindAgents()
    func routeToBlogs(url: String, title: String?)
    func routeToLocationForTransactions(purpose: HomePurpose)
    func routeToAllBlogs()
    func routeToNearbySearch(location: LocationHit)
    func routeToSavedSearch(savedSearchData: [String: Any], resolvedLocations: [LocationHit])
    func routeToAllFavorites()
    func routeToAllSavedSearches()
    func routeToPropertyDetail(with externalId: String)
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: HomeViewController?
    private let navigation: HomeNavigationAdapter
    
    init(navigation: HomeNavigationAdapter) {
        self.navigation = navigation
    }
    
    // MARK: - Routing logic
    func routeToLocationSearch(purpose: HomePurpose) {
        navigation.navigateToLocationSearch(from: viewController, purpose: purpose)
    }
    
    func routeToLocationForProjects() {
        navigation.navigateToLocationForProjects(from: viewController)
    }
    
    func routeToDubaiTransaction() {
        navigation.navigateToDubaiTransaction(from: viewController)
    }
    
    func routeToFindAgents() {
        navigation.navigateToFindAgents(from: viewController)
    }
    
    func routeToBlogs(url: String, title: String?) {
        navigation.navigateToBlogs(url: url, title: title, from: viewController)
    }
    
    func routeToLocationForTransactions(purpose: HomePurpose) {
        navigation.navigateToLocationForTransactions(from: viewController, purpose: purpose)
    }
    
    func routeToAllBlogs() {
        navigation.naviagteToAllBlogs(from: viewController)
    }
    
    func routeToNearbySearch(location: LocationHit) {
        navigation.navigateToNearbySearch(location: location, from: viewController)
    }
    
    func routeToSavedSearch(savedSearchData: [String: Any], resolvedLocations: [LocationHit]) {
        navigation.navigateToSavedSearch(savedSearchData: savedSearchData, resolvedLocations: resolvedLocations, from: viewController)
    }
    
    func routeToAllFavorites() {
        navigation.navigateToAllFavorites(from: viewController)
    }
    
    func routeToAllSavedSearches() {
        navigation.navigateToAllSavedSearches(from: viewController)
    }
    
    func routeToPropertyDetail(with externalId: String) {
        navigation.navigateToPropertyDetail(with: externalId, from: viewController)
    }
}
