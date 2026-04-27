//
//  HomeWorker.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import NetworkLayer
import SearchService
import UIKit

protocol HomeWorkerLogic: NewProjectsWorkerLogic, FavouritesWorkerLogic, PopularSearchWorkerLogic, LocationWorkerLogic, AnyObject {
    func fetchLatestBlogs() async throws -> [Blog]
    func fetchSavedSearches(userID: String) async throws -> [SavedSearch]
    func fetchRecentSearches() async -> [HomeScreenRecentSearch]
}

final class HomeWorker: HomeWorkerLogic {
    
    // MARK: - Properties
    private var networking: HomeNetworkingAdapter
    private var environment: HomeEnvironmentAdapter
    private var newProjectsWorker: NewProjectsWorkerLogic
    private var favouritesWorker: FavouritesWorkerLogic
    private var popularSearchWorker: PopularSearchWorkerLogic
    private var locationWorker: LocationWorkerLogic
    
    init(networking: HomeNetworkingAdapter, environment: HomeEnvironmentAdapter) {
        self.networking = networking
        self.environment = environment
        
        self.newProjectsWorker = NewProjectsWorker(
            searchService: networking.searchService,
            networkingService: networking.networkingService,
            projectsIndexName: environment.algoliaProjectIndex
        )
        
        self.favouritesWorker = FavouritesWorker(
            networking: networking.networkingService,
            searchService: networking.searchService,
            algoliaListingIndex: environment.algoliaListingIndex
        )
        
        self.popularSearchWorker = PopularSearchWorker(
            networking: networking.networkingService,
            dldBaseUrl: environment.dldBaseUrl
        )
        
        self.locationWorker = LocationWorker(
            searchService: networking.searchService,
            algoliaLocationIndex: environment.algoliaLocationIndex
        )
    }
    
    func fetchLatestBlogs() async throws -> [Blog] {
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            HomeModule.shared.environment.blogAuthorizationHeaderKey: HomeModule.shared.environment.blogAuthorization
        ]
        
        let queryItems = [
            "lang" :"en",
            "category" : "market-trends"
        ]
        
        let request = APIRequestBuilder.create(
            path: "/mybayut/wp-json/bayutapi/v2/latest/",
            type: .get,
            encoding: .url,
            params: queryItems,
            headers: headers,
            cache: .none,
            shouldHandleCookies: true,
            fullURL: "https://www.bayut.com/mybayut/wp-json/bayutapi/v2/latest/"
        )
        
        return try await networking.networkingService.execute(request: request)
    }
    
    func fetchSavedSearches(userID: String) async throws -> [SavedSearch] {
        let request = APIRequestBuilder.create(
            path: "/api/user/\(userID)/searches/saved/",
            type: .get,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            cache: .none,
            shouldHandleCookies: true
        )
            
        return try await networking.networkingService.execute(request: request)
    }
    
    func fetchRecentSearches() async -> [HomeScreenRecentSearch] {
        return await HomeModule.shared.environment.recentSearchesProvider.fetchRecentSearches(limit: 5)
    }
}

extension HomeWorker: NewProjectsWorkerLogic {
    func fetchNewProjects(locationID: String, cplIDs: [String]?) async -> [ProjectHit] {
        return await newProjectsWorker.fetchNewProjects(locationID: locationID, cplIDs: cplIDs)
    }
}

extension HomeWorker: FavouritesWorkerLogic {
    func fetchFavoritesIDs(userID: String) async throws -> [String] {
        return try await favouritesWorker.fetchFavoritesIDs(userID: userID)
    }
    
    func fetchFavoritesProperties(ids: [String]) async throws -> [Property] {
        return try await favouritesWorker.fetchFavoritesProperties(ids: ids)
    }
    
    func toggleFavorite(userID: String, externalID: String) async throws {
        try await favouritesWorker.toggleFavorite(userID: userID, externalID: externalID)
    }
}

extension HomeWorker: PopularSearchWorkerLogic {
    func fetchPopularSectionMetadata(locationQuery: String) async throws -> PopularSectionResponse {
        return try await popularSearchWorker.fetchPopularSectionMetadata(locationQuery: locationQuery)
    }
}

extension HomeWorker: LocationWorkerLogic {
    func fetchLocations(slugs: [String]) async throws -> [LocationHit] {
        return try await locationWorker.fetchLocations(slugs: slugs)
    }
    
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [LocationHit] {
        return try await locationWorker.fetchNearbyLocations(latitude: latitude, longitude: longitude)
    }
}
