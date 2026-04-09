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
}

final class HomeWorker: HomeWorkerLogic {
    
    private var networking: HomeNetworkingAdapter
    
    private enum Constants {
        static let listingsIndexName = "bayut-development-ads-en"
        static let projectIndexName = "bayut-development-ads-project-en"
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
}
