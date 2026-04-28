//
//  CGFloat+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 13/02/2026.
//

import UIKit

extension CGFloat {
    static let zero: CGFloat = 0
    static let heading: CGFloat = 24
    static let large: CGFloat = 20
    static let standard: CGFloat = 16
    static let small: CGFloat = 12
    static let mediumSmall: CGFloat = 10
    static let extraSmall: CGFloat = 8
    static let little: CGFloat = 6
    static let tiny: CGFloat = 4
    static let standardBorderWidth : CGFloat = 1
    static let sectionTopSpace: CGFloat = 20
    static var ipadLandscapeMarginPadding: CGFloat { 0.16 * UIScreen.main.bounds.size.width }
    static var ipadPortraitMarginPadding: CGFloat { 0.11 * UIScreen.main.bounds.size.width }
    static var ipadMarginPadding: CGFloat {
        return UIApplication.shared.statusBarOrientation.isLandscape ? ipadLandscapeMarginPadding : ipadPortraitMarginPadding
    }
}
