//
//  HomeSectionBuilder.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

final class HomeSectionBuilder {
    
    // MARK: - Persistent Actions (same instances reused on every rebuild)
    let recentSearchesActions = RecentSearchesActions()
    let truBrokerActions = TruBrokerBannerActions(delegate: nil)
    let sellerLeadsActions = SellerLeadsBannerActions(delegate: nil)
    let railingActions = RailingActions()
    let savedSearchesActions = SavedSearchesActions()
    let newProjectsActions = NewProjectsActions()
    let favouritesActions = FavouritesActions()
    let popularSearchActions = PopularSearchActions()
    let nearbyActions = NearbyLocationsActions()
    let blogsActions = BlogsActions()
    
    // MARK: - Delegate Update
    // Called before every build to refresh the weak delegate on all actions.
    func setDelegate(_ delegate: (
        RecentSearchesActionsDelegate &
        TruBrokerBannerActionsDelegate &
        SellerLeadsBannerActionsDelegate &
        RailingActionsDelegate &
        SavedSearchesActionsDelegate &
        NewProjectsActionsDelegate &
        FavouritesActionsDelegate &
        PopularSearchActionsDelegate &
        NearbyLocationsActionsDelegate &
        BlogsActionsDelegate
    )?) {
        recentSearchesActions.delegate = delegate
        truBrokerActions.delegate = delegate
        sellerLeadsActions.delegate = delegate
        railingActions.delegate = delegate
        savedSearchesActions.delegate = delegate
        newProjectsActions.delegate = delegate
        favouritesActions.delegate = delegate
        popularSearchActions.delegate = delegate
        nearbyActions.delegate = delegate
        blogsActions.delegate = delegate
    }
    
    func buildSections(sectionsData: Home.HomeSections) -> [AnySection] {
        var sections: [AnySection] = []
        
        // Recent Searches
        let recentSearchesGroup = RecentSearchesGroup(
            title: "str_recent_searches".localized(),
            searches: sectionsData.recentSearches,
            actions: recentSearchesActions
        )
        sections.append(contentsOf: recentSearchesGroup.buildSections())
        
        // Append TruBroker Banner
        if sectionsData.showTruBrokerBanner {
            let truBrokerBannerSection = TruBrokerBannerSection(actions: truBrokerActions)
            sections.append(AnySection(truBrokerBannerSection, isCustomizable: false))
        }
        
        // Append SellerLeads Banner
        if sectionsData.showSellerLeadsBanner {
            let sellerLeadsBannerSection = SellerLeadsBannerSection(actions: sellerLeadsActions)
            sections.append(AnySection(sellerLeadsBannerSection, isCustomizable: false))
        }

        // MARK: - Build Railing Carousel
        let railingCellTypes: [RailingCellType] = [
            .truEstimate,
            .bayutGPT,
            .dubaiTransactions,
            .commuteSearch
        ]
        
        let railingGroup = RailingGroup(cellTypes: railingCellTypes, actions: railingActions)
        sections.append(contentsOf: railingGroup.buildSections())
        
        // MARK: - Stories Section
        if let storiesProvider = HomeModule.shared.storiesProvider,
           storiesProvider.hasContent,
           let storiesView = storiesProvider.getStoriesWidgetView() {
            let storiesSection = StoriesSection(hostedView: storiesView, viewHeight: HomeModule.shared.environment.storiesViewHeight)
            sections.append(AnySection(storiesSection, isCustomizable: false))
        }
        
        let savedSearchGroup = SavedSearchesGroup(
            title: "savedSearches".localized(),
            viewAllTitle: "viewAllSavedSearches".localized(),
            searches: sectionsData.savedSearches,
            actions: savedSearchesActions
        )
        sections.append(contentsOf: savedSearchGroup.buildSections())
        
        // MARK: - Build New Projects Group
        let newProjectsGroup = NewProjectsGroup(
            headerTitle: "browseNewProjectsInUAE".localized(),
            viewAllTitle: .empty,
            projects: sectionsData.projects,
            locations: sectionsData.locations,
            actions: newProjectsActions
        )
        sections.append(contentsOf: newProjectsGroup.buildSections())
        
        let favouritesGroup = FavouritesGroup(
            title: "favourites".localized(),
            viewAllTitle: "viewAllFavourites".localized(),
            properties: sectionsData.favourites,
            actions: favouritesActions
        )
        sections.append(contentsOf: favouritesGroup.buildSections())
        
        let popularSearchGroup = PopularSearchGroup(
            title: String(format: "popularIn".localized(), sectionsData.popularSearchDisplayedLocation ?? sectionsData.selectedLocation),
            purposes: sectionsData.purposes,
            selectedPurpose: sectionsData.selectedPurpose,
            searches: sectionsData.popularSearches,
            actions: popularSearchActions
        )
        sections.append(contentsOf: popularSearchGroup.buildSections())
        
        let nearbyGroup = NearbyLocationsGroup(
            title: "lookupNearbyLocations".localized(),
            isLocationEnabled: sectionsData.isLocationEnabled,
            locations: sectionsData.nearbyLocations,
            actions: nearbyActions,
            userCoordinates: sectionsData.userCoordinates
        )
        sections.append(contentsOf: nearbyGroup.buildSections())
        
        let blogsGroup = BlogsGroup(
            title: "fromOurBlogs".localized(),
            viewAllTitle: "exploreArticles".localized(),
            blogs: sectionsData.blogs,
            actions: blogsActions
        )
        sections.append(contentsOf: blogsGroup.buildSections())
        
        // MARK: - Marketing Banner Dynamic Injection
        if let config = sectionsData.marketingBannerConfig, config.isEnabled {
            let bannerSection = MarketingBannerSection(imageUrl: config.bannerImageUrl)
            let anySection = AnySection(bannerSection, isCustomizable: false)
            
            let insertionIndex = min(max(0, config.index), sections.count)
            sections.insert(anySection, at: insertionIndex)
        }
        
        return sections
    }
}
