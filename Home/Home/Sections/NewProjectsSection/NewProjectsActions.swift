//
//  NewProjectsActions.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol NewProjectsActionsDelegate: AnyObject {
    func newProjectsDidTapCard(at index: Int)
    func newProjectsDidTapLocationChip(externalID: String)
    func newProjectsDidTapViewAll()
}

// MARK: - Actions Container
struct NewProjectsActions {
    weak var delegate: NewProjectsActionsDelegate?
    
    init(delegate: NewProjectsActionsDelegate? = nil) {
        self.delegate = delegate
    }
    
    static func empty() -> NewProjectsActions {
        NewProjectsActions()
    }
}
