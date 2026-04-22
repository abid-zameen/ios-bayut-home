//
//  PopularSearchActions.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import Foundation

protocol PopularSearchActionsDelegate: AnyObject {
    func popularSearchDidSelectPurpose(at index: Int, purpose: PopularSearchPurpose)
    func popularSearchDidSelectSearchItem(at index: Int)
}

struct PopularSearchActions {
    weak var delegate: PopularSearchActionsDelegate?
}
