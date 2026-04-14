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
}

final class HomeInteractor: HomeBusinessLogic {
    let adapter: HomeModuleAdapter
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic
    
    var selectedNewProjectsLocationID: String = Emirates.dubai.rawValue
    
    // MARK: - Initialization
    init(adapter: HomeModuleAdapter, worker: HomeWorkerLogic) {
        self.adapter = adapter
        self.worker = worker
        setupStoriesListener()
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
        var newProjects: [ProjectHit] = []
        var favouriteProperties: [Property] = []
        var latestBlogs: [Blog] = []
        var savedSearches: SavedSearchesData? = nil
        var recentSearches: [HomeScreenRecentSearch] = []
        
        var nearbyLocations: [Location] = []
        let isLocationAuthorized = adapter.environment.isLocationAuthorized
        
        do {
            if let userID = adapter.environment.userID {
                let favIds = try await worker.fetchFavoritesIDs(userID: userID)
                if !favIds.isEmpty {
                    favouriteProperties = try await worker.fetchFavoritesProperties(ids: favIds)
                }
                
                let rawSearches = try await worker.fetchSavedSearches(userID: userID)
                let slicedSearches = Array(rawSearches.prefix(5))
                
                let allSlugs = slicedSearches.compactMap { $0.params.locations }.flatMap { $0 }
                let uniqueSlugs = Array(Set(allSlugs))
                let resolvedLocations = try await worker.fetchLocations(slugs: uniqueSlugs)
                
                savedSearches = SavedSearchesData(searches: slicedSearches, resolvedLocations: resolvedLocations)
            }
            
            latestBlogs = try await worker.fetchLatestBlogs()
            recentSearches = await worker.fetchRecentSearches()
            
            // CPL Logic
            let cplIDs = adapter.utilities.supportedLocIDsCPL[selectedNewProjectsLocationID]
            newProjects = await worker.fetchNewProjects(locationID: selectedNewProjectsLocationID, cplIDs: cplIDs)
            
            if isLocationAuthorized, let coords = adapter.environment.userCoordinates {
                nearbyLocations = try await worker.fetchNearbyLocations(latitude: coords.lat, longitude: coords.lon)
            }
        } catch {
            print("HomeInteractor: Error loading data: \(error)")
        }
        
        await MainActor.run {
            let config = adapter.utilities.popularSearchConfig
            let availablePurposes = config.purposeConfigs.map { $0.purpose }
            let initialPurpose = availablePurposes.first ?? .rent
            
            let response = Home.Response(
                projects: newProjects,
                locations: [],
                favourites: favouriteProperties,
                savedSearches: savedSearches,
                blogs: latestBlogs,
                nearbyLocations: nearbyLocations,
                isLocationEnabled: isLocationAuthorized,
                popularSearches: [],
                popularSearchConfig: config,
                purposes: availablePurposes,
                selectedPurpose: .rent,
                recentSearches: recentSearches
            )
            presenter?.presentData(data: response)
        }
    }
    
    func requestLocationAuthorization() {
        adapter.environment.requestLocationAuthorization()
    }
    
    func didSelectNewProjectsLocation(id: String) async {
        guard selectedNewProjectsLocationID != id else { return }
        selectedNewProjectsLocationID = id
        
        // CPL Logic
        let cplIDs = adapter.utilities.supportedLocIDsCPL[id]
        let projects = await worker.fetchNewProjects(locationID: id, cplIDs: cplIDs)
        
        await MainActor.run {
            presenter?.presentNewProjects(projects: projects, selectedLocationID: id)
        }
    }
}
