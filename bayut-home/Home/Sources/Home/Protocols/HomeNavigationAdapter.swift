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
}
