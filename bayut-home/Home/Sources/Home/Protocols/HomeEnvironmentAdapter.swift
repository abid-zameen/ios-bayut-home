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
}
