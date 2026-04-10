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
}

final class HomeInteractor: HomeBusinessLogic {
    let adapter: HomeModuleAdapter
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic
    
    // MARK: - Initialization
    init(adapter: HomeModuleAdapter, worker: HomeWorkerLogic) {
        self.adapter = adapter
        self.worker = worker
    }
    
    
    // MARK: - HomeBusinessLogic
    func loadData() async {
        var favouriteProperties: [Property] = []
        var latestBlogs: [Blog] = []
        var savedSearches: SavedSearchesData? = nil
        
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
                projects: [],
                locations: [],
                favourites: favouriteProperties,
                savedSearches: savedSearches,
                blogs: latestBlogs,
                nearbyLocations: nearbyLocations,
                isLocationEnabled: isLocationAuthorized,
                popularSearches: [],
                popularSearchConfig: config,
                purposes: availablePurposes,
                selectedPurpose: .rent
            )
            presenter?.presentData(data: response)
        }
    }
    
    func requestLocationAuthorization() {
        adapter.environment.requestLocationAuthorization()
    }
}
