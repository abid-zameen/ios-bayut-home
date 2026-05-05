//
//  HighlightableCollectionViewCell.swift
//  Home
//
//  Created by Hammad Shahid on 10/04/2026.
//

import UIKit

protocol HomeRoutingLogic: AnyObject {
    func routeToLocationSearch(purpose: HomePurpose)
    func routeToLocationForProjects()
    func routeToDubaiTransaction()
    func routeToFindAgents()
    func routeToBlogs(url: String, title: String?)
    func routeToLocationForTransactions(purpose: HomePurpose)
    func routeToAllBlogs()
    func routeToNearbySearch(location: LocationHit)
    func routeToSavedSearch(savedSearchData: [String: Any], resolvedLocations: [LocationHit])
    func routeToAllFavorites()
    func routeToAllSavedSearches()
    func routeToPropertyDetail(with externalId: String)
    func routeToProjectDetail(hit: ProjectHit)
    func routeToProjectsScreen(externalID: String, displayName: String)
    func routeToRecentSearch(recentSearch: HomeScreenRecentSearch)
    func routeToRailing(type: RailingCellType)
    func routeToCommuteSearch()
    func routeToTruEstimate()
    func routeToGPT()
    func routeToSellerLeadsForm(purpose: HomePurpose?)
    func routeToPopularSearch(category: PopularSearchCategory, purpose: PopularSearchPurpose)
    func routeToFavoriteAction(action: FavouriteCellAction, property: Property)
    func navigateToOnboarding(from viewController: UIViewController?)
    func navigateToOnboardingV2(from viewController: UIViewController?)
    func routeToAppReview()
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: HomeViewController?
    private let navigation: HomeNavigationAdapter
    
    init(navigation: HomeNavigationAdapter) {
        self.navigation = navigation
    }
    
    // MARK: - Routing logic
    func routeToLocationSearch(purpose: HomePurpose) {
        navigation.navigateToLocationSearch(from: viewController, purpose: purpose)
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
    
    func routeToBlogs(url: String, title: String?) {
        navigation.navigateToBlogs(url: url, title: title, from: viewController)
    }
    
    func routeToLocationForTransactions(purpose: HomePurpose) {
        navigation.navigateToLocationForTransactions(from: viewController, purpose: purpose)
    }
    
    func routeToAllBlogs() {
        navigation.naviagteToAllBlogs(from: viewController)
    }
    
    func routeToNearbySearch(location: LocationHit) {
        navigation.navigateToNearbySearch(location: location, from: viewController)
    }
    
    func routeToSavedSearch(savedSearchData: [String: Any], resolvedLocations: [LocationHit]) {
        navigation.navigateToSavedSearch(savedSearchData: savedSearchData, resolvedLocations: resolvedLocations, from: viewController)
    }
    
    func routeToAllFavorites() {
        navigation.navigateToAllFavorites(from: viewController)
    }
    
    func routeToAllSavedSearches() {
        navigation.navigateToAllSavedSearches(from: viewController)
    }
    
    func routeToPropertyDetail(with externalId: String) {
        navigation.navigateToPropertyDetail(with: externalId, from: viewController)
    }
    
    func routeToProjectDetail(hit: ProjectHit) {
        let jsonDict = hit.tojsonDict(imageBaseUrl: HomeModule.shared.environment.imageBaseUrl)
        navigation.navigateToProjectDetail(hit: hit, jsonDict: jsonDict, from: viewController)
    }
    
    func routeToProjectsScreen(externalID: String, displayName: String) {
        navigation.navigateToProjectsScreen(externalID: externalID, displayName: displayName, from: viewController)
    }
    
    func routeToRecentSearch(recentSearch: HomeScreenRecentSearch) {
        navigation.navigateToRecentSearch(recentSearch: recentSearch, from: viewController)
    }
    
    func routeToRailing(type: RailingCellType) {
        switch type {
        case .truEstimate:
            routeToTruEstimate()
        case .truBroker:
            routeToFindAgents()
        case .dubaiTransactions:
            routeToDubaiTransaction()
        case .commuteSearch:
            routeToCommuteSearch()
        case .bayutGPT:
            routeToGPT()
        case .findAnAgency:
             routeToFindAgents()
        default:
            break
        }
    }
    
    func routeToCommuteSearch() {
        navigation.navigateToCommuteSearch(from: viewController)
    }
    
    func routeToTruEstimate() {
        navigation.navigateToTruEstimate(from: viewController)
    }
    
    func routeToGPT() {
        navigation.navigateToGPT(from: viewController)
    }
    
    func routeToSellerLeadsForm(purpose: HomePurpose?) {
        navigation.navigateToSellerLeadsForm(with: purpose, from: viewController)
    }
    
    func routeToPopularSearch(category: PopularSearchCategory, purpose: PopularSearchPurpose) {
        navigation.navigateToPopularSearch(category: category, purpose: purpose, from: viewController)
    }
    
    func routeToFavoriteAction(action: FavouriteCellAction, property: Property) {
        navigation.navigateToFavoriteAction(action: action, from: viewController)
    }
    
    func navigateToOnboarding(from viewController: UIViewController?) {
        navigation.navigateToOnboarding(from: viewController)
    }
    
    func navigateToOnboardingV2(from viewController: UIViewController?) {
        navigation.navigateToOnboardingV2(from: viewController)
    }
    
    func routeToAppReview() {
        navigation.navigateToAppReviewFlow(from: viewController)
    }
}
