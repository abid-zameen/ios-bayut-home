//
//  HomeInteractor+Tracking.swift
//  Home
//
//  Created by Hammad Shahid on 22/04/2026.
//

import Foundation

protocol HomeTrackingLogic {
    func trackPageView()
    func trackSectionImpression(pageSection: String)
    func trackBlogClick(at index: Int)
    func trackBlogViewAll()
    func trackPopularSearchClick(at index: Int)
    func trackRecentSearchClick(at index: Int)
    func trackSavedSearchClick(at index: Int)
    func trackFavouriteClick(at index: Int)
    func trackNearbyLocationClick(at index: Int)
}

extension HomeInteractor: HomeTrackingLogic {
    
    func trackPageView() {
        tracker?.track(.pageView)
    }
    
    func trackSectionImpression(pageSection: String) {
        tracker?.track(.sectionImpression(pageSection: pageSection))
    }
    
    func trackBlogClick(at index: Int) {
        guard case .data(let blogs) = blogsState, index < blogs.count else { return }
        let blog = blogs[index]
        tracker?.track(.blogClick(blogID: blog.blogPostId, title: blog.title, position: index + 1))
    }
    
    func trackBlogViewAll() {
        tracker?.track(.blogViewAll)
    }
    
    func trackPopularSearchClick(at index: Int) {
        guard index < popularSearchPurposes.count else { return }
        let purpose = popularSearchPurposes[index]
        tracker?.track(.popularSearchClick(position: index + 1, title: purpose.rawValue))
    }
    
    func trackRecentSearchClick(at index: Int) {
        guard case .data(let recent) = recentSearchesState, index < recent.count else { return }
        let search = recent[index]
        tracker?.track(.recentSearchClick(position: index + 1, title: search.title))
    }
    
    func trackSavedSearchClick(at index: Int) {
        guard case .data(let saved) = savedSearchesState, index < saved.searches.count else { return }
        let search = saved.searches[index]
        let title = search.name ?? "Saved Search"
        tracker?.track(.savedSearchClick(position: index + 1, title: title))
    }
    
    func trackFavouriteClick(at index: Int) {
        guard case .data(let favourites) = favouritesState, index < favourites.count else { return }
        let property = favourites[index]
        tracker?.track(.favouriteClick(position: index + 1, externalID: property.id))
    }
    
    func trackNearbyLocationClick(at index: Int) {
        guard case .data(let locations) = nearbyLocationsState, index < locations.count else { return }
        let location = locations[index]
        tracker?.track(.nearbyLocationClick(position: index + 1, locationName: location.name ?? ""))
    }
}
