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
    private let projects: [ProjectHit]
    private let locations: [LocationChipViewModel]
    private let actions: NewProjectsActions
    
    init(
        groupId: String = "newProjects",
        displayName: String = "New Projects",
        section: HomeSection? = .main,
        headerTitle: String,
        viewAllTitle: String,
        projects: [ProjectHit],
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
        
        // 1. Title (header) section
        let titleSection = NewProjectsTitleSection(
            title: headerTitle,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Location chips (horizontal scroll)
        if !locations.isEmpty {
            let locationsSection = NewProjectsLocationsSection(
                locations: locations,
                section: section,
                actions: actions
            )
            sections.append(AnySection(locationsSection, isCustomizable: false))
        }
        
        // 3. Projects carousel (horizontal scroll)
        let selectedLocation = locations.first(where: { $0.isSelected })
        let selectedLocationID = selectedLocation?.externalID ?? ""
        
        let isWhatsAppEnabledHome = HomeModule.shared.environment.isProjectWhatsAppEnabledHome
        let isSupportedLoc = HomeModule.shared.utilities.supportedLocIDsCPL.keys.contains(selectedLocationID)
        let showWhatsappButton = isWhatsAppEnabledHome && isSupportedLoc
        
        if !projects.isEmpty {
            let projectsSection = NewProjectsCarouselSection(
                projects: projects,
                showWhatsappButton: showWhatsappButton,
                section: section,
                actions: actions
            )
            sections.append(AnySection(projectsSection, isCustomizable: false))
        }
        
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
        
        return sections
    }
}
