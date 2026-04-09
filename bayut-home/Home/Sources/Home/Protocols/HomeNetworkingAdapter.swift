import Foundation
import NetworkLayer
import SearchService

// MARK: - Home Networking Adapter
/// Protocol for providing networking and search services to the Home module
public protocol HomeNetworkingAdapter {
    var networkingService: Networking { get }
    var searchService: SearchService { get }
}
