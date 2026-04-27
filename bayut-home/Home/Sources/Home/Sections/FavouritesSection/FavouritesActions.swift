//
//  FavouritesActions.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Favourite Actions
public enum FavouriteCellAction: Equatable {
    case verification
    case viewed
    case potw
    case offplan
    case offplanResale
    case history
    case truBroker(url: URL?)
    case paymentPlan
}

protocol FavouritesActionsDelegate: AnyObject {
    func favouritesDidTapCard(at index: Int, with externalId: String)
    func favouritesDidToggleFavorite(at index: Int, with externalId: String)
    func favouritesDidTapAction(_ action: FavouriteCellAction, property: Property)
    func favouritesDidTapViewAll()
}

// MARK: - Actions Container
struct FavouritesActions {
    weak var delegate: FavouritesActionsDelegate?
    
    init(delegate: FavouritesActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
