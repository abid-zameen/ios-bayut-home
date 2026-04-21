//
//  RecentSearchesGroup.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import Foundation

// MARK: - Section Group
final class RecentSearchesGroup: SectionGroup {
    let groupId: String = "recentSearchesGroup"
    let displayName: String = "Recent Searches"
    let section: HomeSection? = .main
    
    private let title: String
    private let searches: Home.DataState<[HomeScreenRecentSearch]>
    private let actions: RecentSearchesActions
    
    init(
        title: String,
        searches: Home.DataState<[HomeScreenRecentSearch]>,
        actions: RecentSearchesActions
    ) {
        self.title = title
        self.searches = searches
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = searches {
            return []
        }
        
        // 1. Title Header
        let titleSection = RecentSearchesTitleSection(title: title, section: section)
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Carousel Section (Handles loading/data internally)
        let carouselSection = RecentSearchesCarouselSection(
            state: searches,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        return sections
    }
}
