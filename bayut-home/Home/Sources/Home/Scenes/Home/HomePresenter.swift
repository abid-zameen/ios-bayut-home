//
//  HomePresenter.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation
import CoreLocation

protocol HomePresentationLogic: AnyObject {
    func presentData(data: Home.Response?)
    func presentNewProjects(projects: [ProjectHit], selectedLocationID: String)
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
    func presentData(data: Home.Response?) {
        guard let viewController = viewController as? HomeViewController else { return }
        self.lastResponse = data
        
        let locations = mapLocationChips(selectedID: Emirates.dubai.rawValue)
        let projects = data?.projects ?? []
        let favourites = data?.favourites ?? []
        let savedSearches = mapSavedSearches(data: data?.savedSearches)
        let blogs = data?.blogs ?? []
        let nearbyLocations = mapNearbyLocations(locations: data?.nearbyLocations, isLocationEnabled: data?.isLocationEnabled ?? false)
        let recentSearches = data?.recentSearches ?? []
        
        // Map Popular Searches
        let popularSearches = mapPopularSearches(
            config: data?.popularSearchConfig,
            selectedPurpose: data?.selectedPurpose ?? .rent
        )
        
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
            popularSearches: popularSearches,
            popularSearchConfig: data?.popularSearchConfig,
            purposes: purposes,
            selectedPurpose: data?.selectedPurpose ?? .rent,
            recentSearches: recentSearches,
            viewController: viewController)
        )
        
        let viewModel = Home.HomeViewModel(sections: sections, animated: false)
        viewController.displaySections(viewModel: viewModel)
    }
    
    @MainActor
    func presentNewProjects(projects: [ProjectHit], selectedLocationID: String) {
        guard let viewController = viewController as? HomeViewController,
              let lastResponse = self.lastResponse else { return }
        
        let locations = mapLocationChips(selectedID: selectedLocationID)
        
        let sectionsBuilder = HomeSectionBuilder()
        let sections = sectionsBuilder.buildSections(sectionsData: Home.HomeSections(
            projects: projects,
            locations: locations,
            favourites: lastResponse.favourites, // Use cached data
            savedSearches: mapSavedSearches(data: lastResponse.savedSearches),
            blogs: lastResponse.blogs,
            nearbyLocations: mapNearbyLocations(locations: lastResponse.nearbyLocations, isLocationEnabled: lastResponse.isLocationEnabled),
            isLocationEnabled: lastResponse.isLocationEnabled,
            popularSearches: mapPopularSearches(config: lastResponse.popularSearchConfig, selectedPurpose: lastResponse.selectedPurpose),
            popularSearchConfig: lastResponse.popularSearchConfig,
            purposes: lastResponse.purposes,
            selectedPurpose: lastResponse.selectedPurpose,
            recentSearches: lastResponse.recentSearches,
            viewController: viewController)
        )
        
        let viewModel = Home.HomeViewModel(sections: sections, animated: true)
        viewController.displaySections(viewModel: viewModel)
    }
    
    // MARK: - Helpers
    private func mapPopularSearches(config: PopularSearchConfig?, selectedPurpose: PopularSearchPurpose) -> [PopularSearch] {
        guard let config = config else { return [] }
        
        let purposeConfig = config.purposeConfigs.first { $0.purpose == selectedPurpose }
        let categories = purposeConfig?.categories ?? []
        let locations = adapter.utilities.lastSearchedLocations ?? adapter.utilities.defaultCityName
        
        return categories.map { slug in
            let info = adapter.utilities.getPropertyTypeInfo(category: slug)
            let title = info?.titlePlural ?? slug.capitalized
            
            return PopularSearch(
                title: title,
                location: "in \(locations)",
                iconName: advanceImagesMap[slug] ?? "adv-res-apartments"
            )
        }
    }
    
    private func mapNearbyLocations(locations: [Location]?, isLocationEnabled: Bool) -> [NearbyLocation] {
        guard isLocationEnabled, let locations = locations else { return [] }
        
        let userCoords = adapter.environment.userCoordinates
        let userLocation = userCoords.map { CLLocation(latitude: $0.lat, longitude: $0.lon) }
        
        return locations.compactMap { location in
            let name = location.name ?? ""
            
            var distanceString: String? = nil
            if let userLocation = userLocation, let geo = location.geography {
                let loc = CLLocation(latitude: geo.lat, longitude: geo.lng)
                let distance = userLocation.distance(from: loc) // meters
                
                if distance >= 1000 {
                    let km = Int(round(distance / 1000.0))
                    distanceString = "\(km) km"
                } else {
                    let meters = Int(round(distance))
                    distanceString = "\(meters) m"
                }
            }
            
            return NearbyLocation(
                name: name,
                distance: distanceString ?? "",
                city: location.cityName ?? ""
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
    
    private func mapSavedSearches(data: SavedSearchesData?) -> [SavedSearchesModel] {
        guard let data = data else { return [] }
        return data.searches.map { search in
            let info = search.params
            let propertyTypeInfo = adapter.utilities.getPropertyTypeInfo(category: info.category)
            
            let displayTitle = propertyTypeInfo?.titlePlural ?? search.name
            
            var locationString = ""
            if let slugs = info.locations, !slugs.isEmpty {
                let matchedLocations = data.resolvedLocations.filter { location in
                    guard let slug = location.slug else { return false }
                    return slugs.contains(slug)
                }
                
                if !matchedLocations.isEmpty {
                    locationString = matchedLocations.compactMap { $0.name }.joined(separator: ", ")
                } else {
                    locationString = adapter.utilities.defaultCityName
                }
            } else {
                locationString = adapter.utilities.defaultCityName
            }
            
            let isParent = propertyTypeInfo?.isParent ?? true
            let showIcon = !isParent
            let imageName = showIcon ? advanceImagesMap[info.category] : nil
            
            return SavedSearchesModel(
                name: search.name,
                displayTitle: displayTitle,
                location: locationString,
                showIcon: showIcon,
                imageName: imageName
            )
        }
    }
    
    private var advanceImagesMap: [String: String] {
        return [
            "hotel-apartments" : "adv-res-hotel-apartments",
            "apartments" : "adv-res-apartments",
            "residential-buildings" : "adv-res-buildings",
            "villas" : "sel-res-villas",
            "residential-lands" : "adv-res-land",
            "chalets" : "sel-res-chalets",
            "rooms" : "sel-res-rooms",
            "offices" : "adv-com-offices",
            "warehouses" : "adv-com-warehouses",
            "shops" : "adv-com-shops",
            "commercial-properties" : "adv-com-properties",
            "agriculture-plots" : "sel-com-agriculture-plots",
            "duplexes" : "sel-res-duplexes",
            "townhouses" : "sel-res-townhouses",
            "residential-land" : "adv-res-land",
            "residential-plots" : "adv-res-land"
        ]
    }
}
