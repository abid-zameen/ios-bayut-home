//
//  NewProjectsWorker.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation
import NetworkLayer
import SearchService

protocol NewProjectsWorkerLogic {
    func fetchNewProjects(locationID: String, cplIDs: [String]?) async -> [ProjectHit]
}

final class NewProjectsWorker: NewProjectsWorkerLogic {
    private let searchService: SearchService
    private let networkingService: Networking
    private let projectsIndexName: String
    
    init(searchService: SearchService, networkingService: Networking, projectsIndexName: String) {
        self.searchService = searchService
        self.networkingService = networkingService
        self.projectsIndexName = projectsIndexName
    }
    
    func fetchNewProjects(locationID: String, cplIDs: [String]? = nil) async -> [ProjectHit] {
        if let cplIDs = cplIDs, !cplIDs.isEmpty {
            return await fetchProjectsCPL(ids: cplIDs)
        }
        
        let baseFilter = "purpose:for-sale AND completionStatus:under-construction AND location.externalID:\(locationID)"
        let apartmentFilter = "\(baseFilter) AND unitCategories.externalID:4"
        let villaFilter = "\(baseFilter) AND unitCategories.externalID:3"
        
        async let apartmentTask = fetchFromAlgolia(filter: apartmentFilter, hitsPerPage: 20)
        async let villaTask = fetchFromAlgolia(filter: villaFilter, hitsPerPage: 20)
        
        var (apartmentHits, villaHits) = await (apartmentTask, villaTask)
        
        var combinedHits: [ProjectHit] = Array(apartmentHits.prefix(8))
        let remainingVillas = villaHits.prefix(4)
        combinedHits.append(contentsOf: remainingVillas)
        
        if combinedHits.count < 12 && apartmentHits.count > 8 {
            let extraApartments = apartmentHits.dropFirst(8).prefix(12 - combinedHits.count)
            combinedHits.append(contentsOf: extraApartments)
        }
        
        return combinedHits.uniqueByID().shuffled()
    }

    private func fetchProjectsCPL(ids: [String]) async -> [ProjectHit] {
        let locIds = ids.joined(separator: ",")
        let queryParams: [String: String] = [
            "category": "1",
            "page_size": "12",
            "location": locIds
        ]
        
        let request = APIRequestBuilder.create(
            path: "/api/projects/cpl",
            type: .get,
            encoding: .url,
            params: queryParams,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            cache: .appSession,
            shouldHandleCookies: true
        )
        
        do {
            let response: [ProjectHit] = try await networkingService.execute(request: request)
            return response.uniqueByID()
        } catch {
            return []
        }
    }
    
    private func fetchFromAlgolia(filter: String, hitsPerPage: Int) async -> [ProjectHit] {
        let request = SearchRequest(
            query: .empty,
            filters: filter,
            hitsPerPage: hitsPerPage,
            attributesToRetrieve: ["*"]
        )
        
        do {
            let result: SearchResult<ProjectHit> = try await searchService.search(query: request, in: self.projectsIndexName)
            return result.hits ?? []
        } catch {
            return []
        }
    }
}
