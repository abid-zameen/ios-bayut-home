//
//  RailingActions.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

// MARK: - Delegate Protocol
protocol RailingActionsDelegate: AnyObject {
    func railingDidTapCard(at index: Int)
    func railingDidTapPageControl(index: Int)
}

// MARK: - Actions Container
struct RailingActions {
    weak var delegate: RailingActionsDelegate?
    
    init(delegate: RailingActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
