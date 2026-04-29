//
//  NearbyLocationsGroup.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

final class NearbyLocationsGroup: SectionGroup {
    let groupId: String = "nearbyLocationsGroup"
    let displayName: String = "lookupNearbyLocations".localized()
    let section: HomeSection? = .main
    
    private let title: String
    private let isLocationEnabled: Bool
    private let locations: Home.DataState<[LocationHit]>
    private let actions: NearbyLocationsActions
    
    init(
        title: String,
        isLocationEnabled: Bool,
        locations: Home.DataState<[LocationHit]>,
        actions: NearbyLocationsActions
    ) {
        self.title = title
        self.isLocationEnabled = isLocationEnabled
        self.locations = locations
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = locations, isLocationEnabled {
            return []
        }
        
        if case .data(let items) = locations, isLocationEnabled, items.isEmpty {
            return []
        }
        
        let titleSection = NearbyLocationsTitleSection(title: title, section: section)
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        if isLocationEnabled {
            let carouselSection = NearbyLocationsCarouselSection(
                state: locations,
                section: section,
                actions: actions
            )
            sections.append(AnySection(carouselSection, isCustomizable: false))
        } else {
            let mapSection = NearbyLocationMapSection(section: section, actions: actions)
            sections.append(AnySection(mapSection, isCustomizable: false))
        }
        
        return sections
    }
}
