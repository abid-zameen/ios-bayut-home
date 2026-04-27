//
//  LocationWorker.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//

import Foundation
import SearchService

protocol LocationWorkerLogic: AnyObject {
    func fetchLocations(slugs: [String]) async throws -> [LocationHit]
    func fetchNearbyLocations(latitude: Double, longitude: Double) async throws -> [LocationHit]
}

final class LocationWorker: LocationWorkerLogic {
    private let searchService: SearchService
    private let algoliaLocationIndex: String
    
    init(searchService: SearchService, algoliaLocationIndex: String) {
        self.searchService = searchService
        self.algoliaLocationIndex = algoliaLocationIndex
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
        
        let result: SearchResult<LocationHit> = try await searchService.search(query: request, in: "\(algoliaLocationIndex)en")
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
        
        let result: SearchResult<LocationHit> = try await searchService.search(query: request, in: "\(algoliaLocationIndex)en")
        return result.hits ?? []
    }
}
