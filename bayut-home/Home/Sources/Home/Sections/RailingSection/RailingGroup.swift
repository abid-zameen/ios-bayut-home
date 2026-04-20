//
//  RailingGroup.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

final class RailingSyncState {
    var currentPage: Int = 0 {
        didSet {
            onPageChangedHandler?(currentPage)
        }
    }
    
    var currentVirtualIndex: Int = 0
    var realCount: Int = 0
    var onPageChangedHandler: ((Int) -> Void)?
    var onInteractionBegan: (() -> Void)?
    var onInteractionEnded: (() -> Void)?
}

// MARK: - Section Group
final class RailingGroup: SectionGroup {
    let groupId: String
    let displayName: String
    let section: HomeSection?
    
    private let cellTypes: [RailingCellType]
    private let actions: RailingActions
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
        self.syncState.realCount = cellTypes.count
    }
    
    func buildSections() -> [AnySection] {
        guard !cellTypes.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        let carouselSection = RailingCarouselSection(
            cellTypes: cellTypes,
            syncState: syncState,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
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
