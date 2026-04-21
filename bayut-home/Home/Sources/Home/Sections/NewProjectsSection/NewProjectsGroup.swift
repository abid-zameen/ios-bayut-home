//
//  NewProjectsGroup.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Section Group
final class NewProjectsGroup: SectionGroup {
    let groupId: String
    let displayName: String
    let section: HomeSection?
    
    private let headerTitle: String
    private let viewAllTitle: String
    private let projects: Home.DataState<[ProjectHit]>
    private let locations: [LocationChipViewModel]
    private let actions: NewProjectsActions
    
    init(
        groupId: String = "newProjects",
        displayName: String = "New Projects",
        section: HomeSection? = .main,
        headerTitle: String,
        viewAllTitle: String,
        projects: Home.DataState<[ProjectHit]>,
        locations: [LocationChipViewModel],
        actions: NewProjectsActions
    ) {
        self.groupId = groupId
        self.displayName = displayName
        self.section = section
        self.headerTitle = headerTitle
        self.viewAllTitle = viewAllTitle
        self.projects = projects
        self.locations = locations
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = projects {
            return []
        }
        
        // 1. Header Section
        let header = NewProjectsTitleSection(title: headerTitle, section: section)
        sections.append(AnySection(header, isCustomizable: false))
        
        // 2. Location chips (always show if available)
        if !locations.isEmpty {
            let locationsSection = NewProjectsLocationsSection(locations: locations, section: section, actions: actions)
            sections.append(AnySection(locationsSection, isCustomizable: false))
        }
        
        // 3. Projects carousel (Handles loading/data internally)
        let selectedLocation = locations.first(where: { $0.isSelected })
        let selectedLocationID = selectedLocation?.externalID ?? ""
        let isWhatsAppEnabledHome = HomeModule.shared.environment.isProjectWhatsAppEnabledHome
        let isSupportedLoc = HomeModule.shared.utilities.supportedLocIDsCPL.keys.contains(selectedLocationID)
        let showWhatsappButton = isWhatsAppEnabledHome && isSupportedLoc
        
        let projectsSection = NewProjectsCarouselSection(
            state: projects,
            showWhatsappButton: showWhatsappButton,
            section: section,
            actions: actions
        )
        sections.append(AnySection(projectsSection, isCustomizable: false))
        
        // 4. View All Section (Only if data is present)
        if case .data(let hits) = projects, !hits.isEmpty {
            let selectedLocationName = selectedLocation?.localizedName ?? ""
            let viewAllTitle = String(format: "View All Projects in %@", selectedLocationName)
            
            let viewAllSection = NewProjectsViewAllSection(
                buttonTitle: viewAllTitle,
                externalID: selectedLocationID,
                displayName: selectedLocationName,
                section: section,
                actions: actions
            )
            sections.append(AnySection(viewAllSection, isCustomizable: false))
        }
        
        return sections
    }
}
