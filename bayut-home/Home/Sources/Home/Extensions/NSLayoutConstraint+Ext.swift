//
//  NSLayoutConstraint+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

extension NSLayoutConstraint {
    /// Helper method to chain priority modification when writing programatic constraints
    func withPriority(_ rawValue: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue)
        return self
    }
    
    func withPriority(_ customPriority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = customPriority
        return self
    }
}
