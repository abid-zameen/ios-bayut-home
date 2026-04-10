//
//  NearbyLocationsGroup.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

final class NearbyLocationsGroup: SectionGroup {
    let groupId: String = "nearbyLocationsGroup"
    let displayName: String = "Nearby Locations"
    let section: HomeSection? = .main
    
    private let title: String
    private let isLocationEnabled: Bool
    private let locations: [NearbyLocation]
    private let actions: NearbyLocationsActions
    
    init(
        title: String,
        isLocationEnabled: Bool,
        locations: [NearbyLocation],
        actions: NearbyLocationsActions
    ) {
        self.title = title
        self.isLocationEnabled = isLocationEnabled
        self.locations = locations
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        if isLocationEnabled && locations.isEmpty {
            return []
        }
        
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = NearbyLocationsTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Conditional Content
        if isLocationEnabled {
            // Show Carousel
            let carouselSection = NearbyLocationsCarouselSection(
                locations: locations,
                section: section,
                actions: actions
            )
            sections.append(AnySection(carouselSection, isCustomizable: false))
        } else {
            // Show Map Cell
            let mapSection = NearbyLocationMapSection(
                section: section,
                actions: actions
            )
            sections.append(AnySection(mapSection, isCustomizable: false))
        }
        
        return sections
    }
}
