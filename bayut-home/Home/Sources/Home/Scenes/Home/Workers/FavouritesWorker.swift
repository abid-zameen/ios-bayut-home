//
//  FavouritesWorker.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//

import Foundation
import NetworkLayer
import SearchService

protocol FavouritesWorkerLogic: AnyObject {
    func fetchFavoritesIDs(userID: String) async throws -> [String]
    func fetchFavoritesProperties(ids: [String]) async throws -> [Property]
    func toggleFavorite(userID: String, externalID: String) async throws
}

final class FavouritesWorker: FavouritesWorkerLogic {
    private let networking: Networking
    private let searchService: SearchService
    private let algoliaListingIndex: String
    
    init(networking: Networking, searchService: SearchService, algoliaListingIndex: String) {
        self.networking = networking
        self.searchService = searchService
        self.algoliaListingIndex = algoliaListingIndex
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
        
        let response: FavoritesIDsResponse = try await networking.execute(request: request)
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
        
        let result: SearchResult<AlgoliaPropertyHit> = try await searchService.search(query: request, in: "\(algoliaListingIndex)en")
        return result.hits?.map { Property(hit: $0) } ?? []
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
        
        try await networking.executeWithoutResponse(request: request)
    }
}
