//
//  FavouritesActions.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol FavouritesActionsDelegate: AnyObject {
    func favouritesDidTapCard(at index: Int)
    func favouritesDidTapViewAll()
}

// MARK: - Actions Container
struct FavouritesActions {
    weak var delegate: FavouritesActionsDelegate?
    
    init(delegate: FavouritesActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
