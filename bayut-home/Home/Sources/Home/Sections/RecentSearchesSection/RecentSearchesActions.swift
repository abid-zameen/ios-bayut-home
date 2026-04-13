//
//  RecentSearchesActions.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol RecentSearchesActionsDelegate: AnyObject {
    func recentSearchesDidTapCard(at index: Int)
}

// MARK: - Actions Container
struct RecentSearchesActions {
    weak var delegate: RecentSearchesActionsDelegate?
    
    init(delegate: RecentSearchesActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
