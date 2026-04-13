//
//  HomeWorker.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import NetworkLayer
import SearchService

protocol HomeWorkerLogic: AnyObject {
    func fetchProjectsData() async
    func fetchFavoritesIDs(userID: String) async throws -> [String]
    func fetchFavoritesProperties(ids: [String]) async throws -> [Property]
    func fetchLatestBlogs() async throws -> [Blog]
    func fetchSavedSearches(userID: String) async throws -> [SavedSearch]
    func fetchLocations(slugs: [String]) async throws -> [Location]
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [Location]
    func fetchRecentSearches() async -> [HomeScreenRecentSearch]
}

final class HomeWorker: HomeWorkerLogic {
    
    private var networking: HomeNetworkingAdapter
    
    private enum Constants {
        static let listingsIndexName = "bayut-development-ads-en"
        static let projectIndexName = "bayut-development-ads-project-en"
        static let locationsIndexName = "bayut-development-locations-en"
    }
    
    init(networking: HomeNetworkingAdapter) {
        self.networking = networking
    }
    
    func fetchProjectsData() async {
        let location = "/dubai"
        
        let request = SearchRequest(
            query: "",
            filters: "(location.slug: \(location))",
            page: 0,
            hitsPerPage:  30,
            facets: nil,
            keywords:  nil,
            numericFilters:  nil,
            attributesToRetrieve: ["*"],
            attributesToHighlight:  nil,
            geoFilter:nil
        )
        
        do {
            let result: SearchResult<AlgoliaPropertyHit> = try await networking.searchService.search(query: request, in: Constants.projectIndexName)
            print(result)
        } catch {
            print("Error \(error)")
        }
    }
    
    func fetchFavoritesIDs(userID: String) async throws -> [String] {
        let request = APIRequestBuilder.create(
            path: "/api/user/\(userID)/favorites/",
            type: .get,
            encoding: .json,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Accept-Language": "en"
            ],
            cache: .none,
            shouldHandleCookies: true
        )
        
        let response: FavoritesIDsResponse = try await networking.networkingService.execute(request: request)
        return response.compactMap { $0.adExternalID }
    }
    
    func fetchFavoritesProperties(ids: [String]) async throws -> [Property] {
        guard !ids.isEmpty else { return [] }
        
        let filterString = ids.map { "externalID:\"\($0)\"" }.joined(separator: " OR ")
        let algoliaFilters = "(\(filterString))"
        
        let request = SearchRequest(
            query: "",
            filters: algoliaFilters,
            page: 0,
            hitsPerPage: ids.count,
            attributesToRetrieve: ["*"]
        )
        
        let result: SearchResult<AlgoliaPropertyHit> = try await networking.searchService.search(query: request, in: Constants.listingsIndexName)
        return result.hits?.map { Property(hit: $0) } ?? []
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
    
    func fetchLocations(slugs: [String]) async throws -> [Location] {
        guard !slugs.isEmpty else { return [] }
        
        let filterString = slugs.map { "slug:\"\($0)\"" }.joined(separator: " OR ")
        let algoliaFilters = "(\(filterString))"
        
        let request = SearchRequest(
            query: "",
            filters: algoliaFilters,
            page: 0,
            hitsPerPage: slugs.count,
            attributesToRetrieve: ["id", "name", "slug", "level", "cityName"]
        )
        
        let result: SearchResult<Location> = try await networking.searchService.search(query: request, in: Constants.locationsIndexName)
        return result.hits ?? []
    }
    
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [Location] {
        
        let filters = "level <= 9 AND level > 1 AND adCount > 0"
        
        let request = SearchRequest(
            query: "",
            filters: filters,
            page: 0,
            hitsPerPage: 25,
            attributesToRetrieve: ["id", "name", "slug", "level", "cityName", "geography", "adCount"],
            geoFilter: GeoFilter(latitude: latitude, longitude: longitude, radius: 20000),
            ranking: ["geo"]
        )
        
        let result: SearchResult<Location> = try await networking.searchService.search(query: request, in: Constants.locationsIndexName)
        return result.hits ?? []
    }
    
    func fetchRecentSearches() async -> [HomeScreenRecentSearch] {
        return await HomeModule.shared.environment.recentSearchesProvider.fetchRecentSearches(limit: 5)
    }
}
