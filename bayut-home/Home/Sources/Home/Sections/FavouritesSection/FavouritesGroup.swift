//
//  FavouritesGroup.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Safe Data Models
struct FavouriteProperty: Hashable {
    let id: String
    let title: String
    let location: String
    let price: String
    let beds: String
    let baths: String
    let area: String
    let imageURL: URL?
}

// MARK: - Section Group
final class FavouritesGroup: SectionGroup {
    let groupId: String = "favouritesGroup"
    let displayName: String = "Favourites"
    let section: HomeSection? = .main
    
    private let title: String
    private let viewAllTitle: String
    private let properties: [FavouriteProperty]
    private let actions: FavouritesActions
    
    init(
        title: String,
        viewAllTitle: String,
        properties: [FavouriteProperty],
        actions: FavouritesActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.properties = properties
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        guard !properties.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = FavouritesTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Properties Carousel
        let carouselSection = FavouritesCarouselSection(
            properties: properties,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Footer
        let viewAllSection = FavouritesViewAllSection(
            buttonTitle: viewAllTitle,
            section: section,
            actions: actions
        )
        sections.append(AnySection(viewAllSection, isCustomizable: false))
        
        return sections
    }
}
