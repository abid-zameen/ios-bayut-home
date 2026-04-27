//
//  HomePresenter.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomePresentationLogic: AnyObject {
    func presentData(data: Home.Response?, animated: Bool)
    func presentSavedSearchRouting(savedSearchData: [String: Any], resolvedLocations: [LocationHit])
    func presentRecentSearchRouting(search: HomeScreenRecentSearch)
    func presentPopularSearchRouting(category: PopularSearchCategory, purpose: PopularSearchPurpose)
    func presentOnboarding()
    func presentOnboardingV2()
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    private let adapter: HomeModuleAdapter
    private var lastResponse: Home.Response?
    
    init(adapter: HomeModuleAdapter) {
        self.adapter = adapter
    }
    
    // MARK: - HomePresentationLogic
    @MainActor
    func presentData(data: Home.Response?, animated: Bool) {
        guard let viewController = viewController as? HomeViewController else { return }
        self.lastResponse = data
        
        let selectedLocID = data?.selectedNewProjectsLocationID ?? Emirates.dubai.rawValue
        let locations = mapLocationChips(selectedID: selectedLocID)
        let projects = data?.projects ?? .loading
        let favourites = data?.favourites ?? .loading
        let savedSearches = mapSavedSearches(state: data?.savedSearches ?? .loading)
        let blogs = data?.blogs ?? .loading
        let nearbyLocations = data?.nearbyLocations ?? .loading
        let recentSearches = data?.recentSearches ?? .loading
        let popularSearchesState: Home.DataState<[PopularSearch]>
        let popularSearchConfig: PopularSearchConfig?
        
        switch data?.popularSearchState ?? .loading {
        case .loading:
            popularSearchesState = .loading
            popularSearchConfig = nil
        case .data(let config):
            let mappedDefault = mapPopularSearches(
                config: config,
                selectedPurpose: data?.selectedPurpose ?? .rent
            )
            popularSearchesState = .data(mappedDefault)
            popularSearchConfig = config
        case .empty:
            popularSearchesState = .empty
            popularSearchConfig = nil
        }
        
        let purposes: [PopularSearchPurpose] = data?.purposes ?? [.buy, .rent]
        
        let sectionsBuilder = HomeSectionBuilder()
        let sections = sectionsBuilder.buildSections(sectionsData: Home.HomeSections(
            projects: projects,
            locations: locations,
            favourites: favourites,
            savedSearches: savedSearches,
            blogs: blogs,
            nearbyLocations: nearbyLocations,
            isLocationEnabled: data?.isLocationEnabled ?? false,
            popularSearches: popularSearchesState,
            popularSearchConfig: popularSearchConfig,
            selectedLocation: adapter.utilities.lastSearchedLocations ?? adapter.utilities.defaultCityName,
            purposes: purposes,
            selectedPurpose: data?.selectedPurpose ?? .rent,
            recentSearches: recentSearches,
            showTruBrokerBanner: data?.showTruBrokerBanner ?? true,
            showSellerLeadsBanner: data?.showSellerLeadsBanner ?? false,
            marketingBannerConfig: adapter.environment.marketingBannerConfig,
            viewController: viewController)
        )
        
        let viewModel = Home.HomeViewModel(sections: sections, animated: animated)
        viewController.displaySections(viewModel: viewModel)
    }
    
    
    @MainActor
    func presentSavedSearchRouting(savedSearchData: [String: Any], resolvedLocations: [LocationHit]) {
        viewController?.displaySavedSearchRouting(savedSearchData: savedSearchData, resolvedLocations: resolvedLocations)
    }
    
    @MainActor
    func presentRecentSearchRouting(search: HomeScreenRecentSearch) {
        viewController?.displayRecentSearchRouting(search: search)
    }
    
    @MainActor
    func presentPopularSearchRouting(category: PopularSearchCategory, purpose: PopularSearchPurpose) {
        viewController?.displayPopularSearchRouting(category: category, purpose: purpose)
    }
    
    @MainActor
    func presentOnboarding() {
        viewController?.displayOnboarding()
    }
    
    @MainActor
    func presentOnboardingV2() {
        viewController?.displayOnboardingV2()
    }
    
    // MARK: - Helpers
    private func mapPopularSearches(config: PopularSearchConfig?, selectedPurpose: PopularSearchPurpose) -> [PopularSearch] {
        guard let config = config else { return [] }
        
        let purposeConfig = config.purposeConfigs.first { $0.purpose == selectedPurpose }
        let categories = purposeConfig?.categories ?? []
        let locations = adapter.utilities.lastSearchedLocations ?? adapter.utilities.defaultCityName
        
        return categories.map { category in
            return PopularSearch(
                title: category.title,
                location: "in \(locations)",
                iconName: category.iconName
            )
        }
    }
    
    private func mapLocationChips(selectedID: String) -> [LocationChipViewModel] {
        return Emirates.allCases.map { emirate in
            LocationChipViewModel(
                name: emirate.displayName,
                localizedName: emirate.displayName.localized(),
                externalID: emirate.rawValue,
                isSelected: emirate.rawValue == selectedID
            )
        }
    }
    
    private func mapSavedSearches(state: Home.DataState<SavedSearchesData>) -> Home.DataState<[SavedSearchesModel]> {
        switch state {
        case .loading: return .loading
        case .empty: return .empty
        case .data(let data):
            let mapped = data.searches.map { search in
                let info = search.params
                let propertyTypeInfo = adapter.utilities.getPropertyTypeInfo(category: info.category ?? .empty)
                
                let displayTitle = propertyTypeInfo?.titlePlural ?? search.name
                
                var locationString: String = .empty
                if let slugs = info.locations, !slugs.isEmpty {
                    let matchedLocations = data.resolvedLocations.filter { location in
                        guard let slug = location.slug else { return false }
                        return slugs.contains(slug)
                    }
                    
                    if !matchedLocations.isEmpty {
                        locationString = matchedLocations.map { $0.localizedName }.joined(separator: ", ")
                    } else {
                        locationString = adapter.utilities.defaultCityName
                    }
                } else {
                    locationString = adapter.utilities.defaultCityName
                }
                
                let isParent = propertyTypeInfo?.isParent ?? true
                let showIcon = !isParent
                let imageName = showIcon ? adapter.utilities.getIconName(for: info.category ?? .empty) : nil
                
                return SavedSearchesModel(
                    name: search.name,
                    displayTitle: displayTitle,
                    location: locationString,
                    showIcon: showIcon,
                    imageName: imageName
                )
            }
            return mapped.isEmpty ? .empty : .data(mapped)
        }
    }
}
