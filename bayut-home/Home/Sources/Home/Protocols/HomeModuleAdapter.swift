import Foundation

// MARK: - Home Module Adapter
/// Main adapter for the Home module providing all necessary dependencies
public protocol HomeModuleAdapter {
    var networking: HomeNetworkingAdapter { get }
    var environment: HomeEnvironmentAdapter { get }
    var utilities: HomeUtilitiesAdapter { get }
    var navigation: HomeNavigationAdapter { get }
    var storiesProvider: HomeStoriesProvider? { get }
    var homeTrackingAdapter: HomeTrackingAdapter { get }
    var ovation: HomeOvationAdapter { get }
}


public final class HomeModule {
    
    // MARK: - Singleton
    private static var _adapter: HomeModuleAdapter?
    
    public static var shared: HomeModuleAdapter {
        guard let adapter = _adapter else {
            fatalError("""
                TruEstimateModule has not been configured.
                Please call TruEstimateModule.configure(_:) in your AppDelegate or SceneDelegate.
                """)
        }
        return adapter
    }
    
    public static func configure(_ adapter: HomeModuleAdapter) {
        _adapter = adapter
    }
    
    public static func reset() {
        _adapter = nil
    }
    
    private init() {}
}
