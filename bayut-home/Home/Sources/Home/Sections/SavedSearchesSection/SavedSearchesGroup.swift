//
//  SavedSearchesGroup.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

final class SavedSearchesGroup: SectionGroup {
    let groupId: String = "savedSearchesGroup"
    let displayName: String = "Saved Searches"
    let section: HomeSection? = .main
    
    private let title: String
    private let viewAllTitle: String
    private let searches: Home.DataState<[SavedSearchesModel]>
    private let actions: SavedSearchesActions
    
    init(
        title: String,
        viewAllTitle: String,
        searches: Home.DataState<[SavedSearchesModel]>,
        actions: SavedSearchesActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.searches = searches
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = searches {
            return []
        }
        
        // 1. Title Header
        let titleSection = SavedSearchesTitleSection(title: title, section: section)
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Carousel Section (Handles loading/data internally)
        let carouselSection = SavedSearchesCarouselSection(
            state: searches,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Section (Only if data is present)
        if case .data(let items) = searches, !items.isEmpty {
            let viewAllSection = SavedSearchesViewAllSection(
                buttonTitle: viewAllTitle,
                section: section,
                actions: actions
            )
            sections.append(AnySection(viewAllSection, isCustomizable: false))
        }
        
        return sections
    }
}
