import UIKit

public protocol HomeNavigationAdapter {
    func navigateToLocationSearch(from viewController: UIViewController?)
    func navigateToLocationForProjects(from viewController: UIViewController?)
    func navigateToDubaiTransaction(from viewController: UIViewController?)
    func navigateToFindAgents(from viewController: UIViewController?)
}
