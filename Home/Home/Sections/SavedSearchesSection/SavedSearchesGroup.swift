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
    private let searches: [SavedSearchesModel]
    private let actions: SavedSearchesActions
    
    init(
        title: String,
        viewAllTitle: String,
        searches: [SavedSearchesModel],
        actions: SavedSearchesActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.searches = searches
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        guard !searches.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = SavedSearchesTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Searches Carousel
        let carouselSection = SavedSearchesCarouselSection(
            searches: searches,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Footer
        let viewAllSection = SavedSearchesViewAllSection(
            buttonTitle: viewAllTitle,
            section: section,
            actions: actions
        )
        sections.append(AnySection(viewAllSection, isCustomizable: false))
        
        return sections
    }
}
