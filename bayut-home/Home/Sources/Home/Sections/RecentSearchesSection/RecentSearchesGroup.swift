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
    private let searches: [HomeScreenRecentSearch]
    private let actions: RecentSearchesActions
    
    init(
        title: String,
        searches: [HomeScreenRecentSearch],
        actions: RecentSearchesActions
    ) {
        self.title = title
        self.searches = searches
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        guard !searches.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = RecentSearchesTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Recent Searches Carousel
        let carouselSection = RecentSearchesCarouselSection(
            searches: searches,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        return sections
    }
}
