//
//  RecentSearchesProvider.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

public protocol RecentSearchesProvider: AnyObject {
    func fetchRecentSearches(limit: Int) async -> [HomeScreenRecentSearch]
}
