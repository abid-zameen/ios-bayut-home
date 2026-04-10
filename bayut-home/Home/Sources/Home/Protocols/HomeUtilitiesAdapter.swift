import Foundation

// MARK: - Home Utilities Adapter
/// Protocol for providing localized strings and property type info from the main app
public protocol HomeUtilitiesAdapter {
    func getPropertyTypeInfo(category: String) -> (titlePlural: String, isParent: Bool)?
    var defaultCityName: String { get }
    var popularSearchConfig: PopularSearchConfig { get }
    var lastSearchedLocations: String? { get }
}
