//
//  FavouritesGroup.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Section Group
final class FavouritesGroup: SectionGroup {
    let groupId: String = "favouritesGroup"
    let displayName: String = "Favourites"
    let section: HomeSection? = .main
    
    private let title: String
    private let viewAllTitle: String
    private let properties: Home.DataState<[Property]>
    private let actions: FavouritesActions
    
    init(
        title: String,
        viewAllTitle: String,
        properties: Home.DataState<[Property]>,
        actions: FavouritesActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.properties = properties
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = properties {
            return []
        }
        
        // 1. Title Header
        let titleSection = FavouritesTitleSection(title: title, section: section)
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Carousel Section (Handles loading/data internally)
        let carouselSection = FavouritesCarouselSection(
            state: properties,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Section (Only if data is present)
        if case .data(let items) = properties, !items.isEmpty {
            let viewAllSection = FavouritesViewAllSection(
                buttonTitle: viewAllTitle,
                section: section,
                actions: actions
            )
            sections.append(AnySection(viewAllSection, isCustomizable: false))
        }
        
        return sections
    }
}
