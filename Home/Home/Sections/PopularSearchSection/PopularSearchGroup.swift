//
//  PopularSearchGroup.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import Foundation

final class PopularSearchGroup: SectionGroup {
    let groupId: String = "popularSearchGroup"
    let displayName: String = "Popular Searches"
    let section: HomeSection? = .main
    
    private let title: String
    private let purposes: [PopularSearchPurpose]
    private let selectedPurpose: PopularSearchPurpose
    private let searches: [PopularSearch]
    private let actions: PopularSearchActions
    
    init(
        title: String,
        purposes: [PopularSearchPurpose],
        selectedPurpose: PopularSearchPurpose,
        searches: [PopularSearch],
        actions: PopularSearchActions
    ) {
        self.title = title
        self.purposes = purposes
        self.selectedPurpose = selectedPurpose
        self.searches = searches
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = PopularSearchTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Purposes (Horizontal Row)
        let purposeSection = PopularSearchPurposeSection(
            purposes: purposes,
            selectedPurpose: selectedPurpose,
            section: section,
            actions: actions
        )
        sections.append(AnySection(purposeSection, isCustomizable: false))
        
        // 3. Searches Carousel
        let carouselSection = PopularSearchCarouselSection(
            searches: searches,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        return sections
    }
}
