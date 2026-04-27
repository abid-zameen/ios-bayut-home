//
//  HomeWorker.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import NetworkLayer
import SearchService
import UIKit

protocol HomeWorkerLogic: AnyObject {
    func fetchNewProjects(locationID: String, cplIDs: [String]?) async -> [ProjectHit]
    func fetchFavoritesIDs(userID: String) async throws -> [String]
    func fetchFavoritesProperties(ids: [String]) async throws -> [Property]
    func fetchLatestBlogs() async throws -> [Blog]
    func fetchSavedSearches(userID: String) async throws -> [SavedSearch]
    func fetchLocations(slugs: [String]) async throws -> [LocationHit]
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [LocationHit]
    func fetchRecentSearches() async -> [HomeScreenRecentSearch]
    func fetchPopularSectionMetadata(locationQuery: String) async throws -> PopularSectionResponse
    func toggleFavorite(userID: String, externalID: String) async throws
}

final class HomeWorker: HomeWorkerLogic {
    
    private var networking: HomeNetworkingAdapter
    private var environment: HomeEnvironmentAdapter
    private lazy var newProjectsWorker: NewProjectsWorkerLogic = {
        return NewProjectsWorker(
            searchService: networking.searchService,
            networkingService: networking.networkingService,
            projectsIndexName: environment.algoliaProjectIndex
        )
    }()
    
    init(networking: HomeNetworkingAdapter, environment: HomeEnvironmentAdapter) {
        self.networking = networking
        self.environment = environment
    }
    
    func fetchNewProjects(locationID: String, cplIDs: [String]?) async -> [ProjectHit] {
        return await newProjectsWorker.fetchProjects(locationID: locationID, cplIDs: cplIDs)
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
        
        let result: SearchResult<AlgoliaPropertyHit> = try await networking.searchService.search(query: request, in: "\(environment.algoliaListingIndex)en")
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
    
    func fetchLocations(slugs: [String]) async throws -> [LocationHit] {
        guard !slugs.isEmpty else { return [] }
        
        let filterString = slugs.map { "slug:\"\($0)\"" }.joined(separator: " OR ")
        let algoliaFilters = "(\(filterString))"
        
        let request = SearchRequest(
            query: "",
            filters: algoliaFilters,
            page: 0,
            hitsPerPage: slugs.count,
            attributesToRetrieve: ["*"]
        )
        
        let result: SearchResult<LocationHit> = try await networking.searchService.search(query: request, in: "\(environment.algoliaLocationIndex)en")
        return result.hits ?? []
    }
    
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [LocationHit] {
        
        let filters = "level <= 9 AND level > 1 AND adCount > 0"
        
        let request = SearchRequest(
            query: "",
            filters: filters,
            page: 0,
            hitsPerPage: 25,
            attributesToRetrieve: ["*"],
            geoFilter: GeoFilter(latitude: latitude, longitude: longitude, radius: 20000),
            ranking: ["geo"]
        )
        
        let result: SearchResult<LocationHit> = try await networking.searchService.search(query: request, in: "\(environment.algoliaLocationIndex)en")
        return result.hits ?? []
    }
    
    func fetchRecentSearches() async -> [HomeScreenRecentSearch] {
        return await HomeModule.shared.environment.recentSearchesProvider.fetchRecentSearches(limit: 5)
    }
    
    func fetchPopularSectionMetadata(locationQuery: String) async throws -> PopularSectionResponse {
        let requestBody = """
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:1 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:total" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:2 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:total" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}
{}
{"size": 0,"query": {"query_string": { "query": "purpose_id:1 AND \(locationQuery) AND property_type_category_id:(1 OR 2) AND num_bedrooms:total AND num_bathrooms:total AND furnishing_status_id:total AND advanced_filter_id:total AND rent_is_paid_frequency_id:total AND property_completion_status_id:off_plan" }},"aggs": {"group": {"terms": { "field": "property_type_id", "size": 30},"aggs": {"sum": { "sum": { "field": "count_live_listings_last_1_day"}},"sort_by_count": {"bucket_sort": { "sort": [ { "sum": { "order": "desc" }}], "size": 4}}}}}, "_source": false, "track_total_hits": false}

"""
        //let url = HomeModule.shared.environment.dldPopularSectionMetadataURL.absoluteString
        let url = "\(environment.dldBaseUrl)property_filters_metadata_prod_alias/_msearch"
        
        let request = APIRequestBuilder.create(
            path: "",
            type: .post,
            encoding: .raw,
            headers: [
                "Content-Type": "application/x-ndjson",
                "Accept": "application/json",
                "Authorization": "Basic YmF5dXRfcmVhZF9hcHBfZXMyOjEjLjVjLTFcditKWlFFeiw="
            ],
            cache: .none,
            shouldHandleCookies: true,
            fullURL: url,
            requestBody: requestBody
        )
        
        return try await networking.networkingService.execute(request: request)
        
    }
    
    func toggleFavorite(userID: String, externalID: String) async throws {
        let request = APIRequestBuilder.create(
            path: "/api/user/\(userID)/favorites/\(externalID)/toggle/",
            type: .post,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            cache: .none,
            shouldHandleCookies: true
        )
        
        try await networking.networkingService.executeWithoutResponse(request: request)
    }
}
