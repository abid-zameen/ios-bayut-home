//
//  HomeInteractor.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func loadData() async
    func requestLocationAuthorization()
    func didSelectNewProjectsLocation(id: String) async
    func updatePopularSearchPurpose(purpose: PopularSearchPurpose)
    func didSelectSavedSearch(at index: Int)
}

final class HomeInteractor: HomeBusinessLogic {
    let adapter: HomeModuleAdapter
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic
    
    var selectedNewProjectsLocationID: String = Emirates.dubai.rawValue
    
    var newProjects: [ProjectHit] = []
    var favouriteProperties: [Property] = []
    var latestBlogs: [Blog] = []
    var savedSearches: SavedSearchesData? = nil
    var recentSearches: [HomeScreenRecentSearch] = []
    
    var nearbyLocations: [LocationHit] = []
    var isLocationAuthorized = false
    
    var popularSearchPurposes: [PopularSearchPurpose] = []
    var selectedPopularPurpose: PopularSearchPurpose = .buy
    var popularSearchConfig = PopularSearchConfig(purposeConfigs: [])
    
    // MARK: - Initialization
    init(adapter: HomeModuleAdapter, worker: HomeWorkerLogic) {
        self.adapter = adapter
        self.worker = worker
        setupStoriesListener()
        isLocationAuthorized = adapter.environment.isLocationAuthorized
        popularSearchConfig = adapter.utilities.popularSearchConfig
        popularSearchPurposes = popularSearchConfig.purposeConfigs.map { $0.purpose }
        selectedPopularPurpose = popularSearchPurposes.first ?? .rent
    }
    
    private func setupStoriesListener() {
        adapter.storiesProvider?.onVisibilityChange = { [weak self] _ in
            Task { @MainActor in
                self?.refreshCurrentData()
            }
        }
    }
    
    private func refreshCurrentData() {
        Task {
            await self.loadData()
        }
    }
    
    
    // MARK: - HomeBusinessLogic
    func loadData() async {
        do {
            if let userID = adapter.environment.userID {
                let favIds = try await worker.fetchFavoritesIDs(userID: userID)
                let slicedFavIds = Array(favIds.prefix(5))
                if !slicedFavIds.isEmpty {
                    let properties = try await worker.fetchFavoritesProperties(ids: slicedFavIds)
                    self.favouriteProperties = slicedFavIds.compactMap { id in
                        properties.first(where: { $0.id == id })
                    }
                }
                
                let rawSearches = try await worker.fetchSavedSearches(userID: userID)
                let slicedSearches = Array(rawSearches.prefix(5))
                
                let allSlugs = slicedSearches.compactMap { $0.params.locations }.flatMap { $0 }
                let uniqueSlugs = Array(Set(allSlugs))
                let resolvedLocations = try await worker.fetchLocations(slugs: uniqueSlugs)
                
                self.savedSearches = SavedSearchesData(searches: slicedSearches, resolvedLocations: resolvedLocations)
            }
            
            self.latestBlogs = Array(try await worker.fetchLatestBlogs().prefix(5))
            self.recentSearches = await worker.fetchRecentSearches()
            
            let cplIDs = adapter.utilities.supportedLocIDsCPL[selectedNewProjectsLocationID]
            self.newProjects = await worker.fetchNewProjects(locationID: selectedNewProjectsLocationID, cplIDs: cplIDs)
            
            if isLocationAuthorized, let coords = adapter.environment.userCoordinates {
                self.nearbyLocations = try await worker.fetchNearbyLocations(latitude: coords.lat, longitude: coords.lon)
            }
        } catch {
            print("HomeInteractor: Error loading data: \(error)")
        }
        
        await MainActor.run {
            presentData()
        }
    }
    
    func presentData() {
        let response = Home.Response(
            projects: newProjects,
            locations: [],
            favourites: favouriteProperties,
            savedSearches: savedSearches,
            blogs: latestBlogs,
            nearbyLocations: nearbyLocations,
            isLocationEnabled: isLocationAuthorized,
            popularSearches: [],
            popularSearchConfig: popularSearchConfig,
            purposes: popularSearchPurposes,
            selectedPurpose: selectedPopularPurpose,
            recentSearches: recentSearches
        )
        presenter?.presentData(data: response)
    }
    
    func requestLocationAuthorization() {
        adapter.environment.requestLocationAuthorization()
    }
    
    func updatePopularSearchPurpose(purpose: PopularSearchPurpose) {
        self.selectedPopularPurpose = purpose
        presentData()
    }
    
    func didSelectNewProjectsLocation(id: String) async {
        guard selectedNewProjectsLocationID != id else { return }
        selectedNewProjectsLocationID = id
        
        let cplIDs = adapter.utilities.supportedLocIDsCPL[id]
        let projects = await worker.fetchNewProjects(locationID: id, cplIDs: cplIDs)
        
        await MainActor.run {
            presenter?.presentNewProjects(projects: projects, selectedLocationID: id)
        }
    }
    
    func didSelectSavedSearch(at index: Int) {
        guard let savedSearches = savedSearches else { return }
        
        let search = savedSearches.searches[index]
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(search),
           let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            presenter?.presentSavedSearchRouting(savedSearchData: dict, resolvedLocations: savedSearches.resolvedLocations)
        }
    }
}
