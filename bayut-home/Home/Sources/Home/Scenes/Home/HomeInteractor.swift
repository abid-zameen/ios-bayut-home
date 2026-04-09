//
//  HomeInteractor.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func loadData() async
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
        
        do {
            if let userID = adapter.environment.userID {
                let favIds = try await worker.fetchFavoritesIDs(userID: userID)
                if !favIds.isEmpty {
                    favouriteProperties = try await worker.fetchFavoritesProperties(ids: favIds)
                }
            }
        } catch {
            print("HomeInteractor: Error loading favorites: \(error)")
        }
        
        await MainActor.run {
            let sectionsData = Home.HomeSections(
                projects: [],
                locations: [],
                favourites: favouriteProperties,
                savedSearches: [],
                blogs: [],
                nearbyLocations: [],
                isLocationEnabled: false,
                popularSearches: [],
                purposes: [.buy, .rent],
                selectedPurpose: .rent,
                viewController: (presenter as? HomePresenter)?.viewController as! HomeViewController
            )
            presenter?.presentData(data: sectionsData)
        }
    }
}
