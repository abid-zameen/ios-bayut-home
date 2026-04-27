import Foundation
import NetworkLayer
import SearchService

// MARK: - Home Networking Adapter
public protocol HomeNetworkingAdapter {
    var networkingService: Networking { get }
    var searchService: SearchService { get }
}
