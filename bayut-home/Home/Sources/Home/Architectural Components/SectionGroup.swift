//
//  SectionGroup.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 24/12/2025.
//

import Foundation

// MARK: - Section Group
protocol SectionGroup {
    var groupId: String { get }
    var displayName: String { get }
    var section: HomeSection? { get }
    
    func buildSections() -> [AnySection]
}
