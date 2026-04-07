//
//  RailingGroup.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Shared Sync State
/// Passed to both sections to handle live state updates without rebuilding VIP arrays
final class RailingSyncState {
    var currentPage: Int = 0 {
        didSet {
            // Signal directly back to the PageControlCell
            onPageChangedHandler?(currentPage)
        }
    }
    var onPageChangedHandler: ((Int) -> Void)?
}

// MARK: - Section Group
final class RailingGroup: SectionGroup {
    let groupId: String
    let displayName: String
    let section: HomeSection?
    
    private let cellTypes: [RailingCellType]
    private let actions: RailingActions
    
    // Create shared sync state reference owned safely by the group during its lifecycle
    private let syncState = RailingSyncState()
    
    init(
        groupId: String = "railingGroup",
        displayName: String = "Internal Products",
        section: HomeSection? = .main,
        cellTypes: [RailingCellType],
        actions: RailingActions
    ) {
        self.groupId = groupId
        self.displayName = displayName
        self.section = section
        self.cellTypes = cellTypes
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        guard !cellTypes.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        // 1. Carousel Section (Continuously writes to SyncState)
        let carouselSection = RailingCarouselSection(
            cellTypes: cellTypes,
            syncState: syncState,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 2. Page Control Footer Cell (Continuously reads from SyncState)
        let pageControlSection = RailingPageControlSection(
            numberOfPages: cellTypes.count,
            syncState: syncState,
            section: section,
            actions: actions
        )
        sections.append(AnySection(pageControlSection, isCustomizable: false))
        
        return sections
    }
}
