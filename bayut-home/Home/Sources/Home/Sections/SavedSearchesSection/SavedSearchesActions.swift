//
//  SavedSearchesActions.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol SavedSearchesActionsDelegate: AnyObject {
    func savedSearchesDidTapCard(at index: Int)
    func savedSearchesDidTapViewAll()
}

final class SavedSearchesActions {
    weak var delegate: SavedSearchesActionsDelegate?
    
    init(delegate: SavedSearchesActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
