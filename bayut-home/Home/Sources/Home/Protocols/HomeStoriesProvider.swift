import UIKit

public protocol HomeStoriesProvider: AnyObject {
    var hasContent: Bool { get }
    var onVisibilityChange: ((Bool) -> Void)? { get set }
    func getStoriesWidgetView() -> UIView?
}
