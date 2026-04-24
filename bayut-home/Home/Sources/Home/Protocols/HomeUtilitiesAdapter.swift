import Foundation

// MARK: - Home Utilities Adapter
/// Protocol for providing localized strings and property type info from the main app
public protocol HomeUtilitiesAdapter {
    func getPropertyTypeInfo(category: String) -> (titlePlural: String, isParent: Bool)?
    var defaultCityName: String { get }
    var popularSearchConfig: PopularSearchConfig { get }
    var lastSearchedLocations: String? { get }
    var supportedLocIDsCPL: [String: [String]] { get }
    var popularSectionLocationQuery: String? { get }
    var popularSectionParentLocationQuery: String? { get }
    func getPopularSearchCategory(for id: Int) -> PopularSearchCategory?
    func getIconName(for category: String) -> String
}
