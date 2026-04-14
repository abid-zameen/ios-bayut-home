import UIKit

protocol HomeRoutingLogic: AnyObject {
    func routeToLocationSearch()
    func routeToLocationForProjects()
    func routeToDubaiTransaction()
    func routeToFindAgents()
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: HomeViewController?
    private let navigation: HomeNavigationAdapter
    
    init(navigation: HomeNavigationAdapter) {
        self.navigation = navigation
    }
    
    // MARK: - Routing logic
    func routeToLocationSearch() {
        navigation.navigateToLocationSearch(from: viewController)
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
}
