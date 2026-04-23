//
//  HomeHeaderLayout.swift
//  Home
//
//  Created by Hammad Shahid on 06/04/2026.
//

import UIKit

/// A pure value type that derives all Home Header animation positions
/// from two screen-level inputs: `statusBarHeight` and `stickyHeight`.
///
struct HomeHeaderLayout {

    // MARK: - Inputs

    /// Height of the status bar / safe area inset from the top of the screen.
    /// Typically 44pt on Face ID devices, 20pt on older iPhones, 59pt on tall notch devices.
    let statusBarHeight: CGFloat

    /// The target height of the header in its fully collapsed/sticky state.
    let stickyHeight: CGFloat

    // MARK: - View Heights (from Figma — screen-independent)

    enum ViewHeight {
        static let logo:       CGFloat = 32
        static let tabs:       CGFloat = 44
        static let aiSearch:   CGFloat = 52
        static let gccSearch:  CGFloat = 48
        static let buildings:  CGFloat = 137
    }

    // MARK: - Design Offsets (XIB-relative offsets from statusBarHeight)
    // These encode the Figma spacing above each element in the expanded state.

    private enum DesignOffset {
        static let logo:         CGFloat = 46   // 44 + 46 = 90
        static let buildings:    CGFloat = 10   // 44 + 20 = 64
        static let tabs:         CGFloat = 140  // 44 + 121 = 165
        static let bottomCurve:  CGFloat = 134  // 44 + 134 = 178
        static let topCurve:     CGFloat = 57   // 44 + 57 = 101 (fixed, not animated)
        static let aiSearchGap:  CGFloat = 8
        static let gccSearchGap: CGFloat = 8
    }

    var logoExpandedTop: CGFloat    { statusBarHeight + DesignOffset.logo }
    var logoExpandedHeight: CGFloat { ViewHeight.logo }

    var buildingsExpandedTop: CGFloat    { statusBarHeight + DesignOffset.buildings }
    var buildingsExpandedHeight: CGFloat { ViewHeight.buildings }

    var bottomCurveExpandedTop: CGFloat     { statusBarHeight + DesignOffset.bottomCurve }
    var bottomCurveCollapsedTop: CGFloat    { -20 }
    var bottomCurveExpandedHeight: CGFloat  { 97 }
    var bottomCurveCollapsedHeight: CGFloat { stickyHeight }


    var tabsExpandedTop: CGFloat     { statusBarHeight + DesignOffset.tabs }
    var tabsCollapsedTopGCC: CGFloat { -50 }
    var tabsCollapsedTopUAE: CGFloat { -50 }

    var aiSearchExpandedTop: CGFloat  { tabsExpandedTop + ViewHeight.tabs + DesignOffset.aiSearchGap }
    var aiSearchCollapsedTop: CGFloat { statusBarHeight }

    var gccSearchExpandedTop: CGFloat  { tabsExpandedTop + ViewHeight.tabs + DesignOffset.gccSearchGap - 25  }
    var gccSearchCollapsedTop: CGFloat { (stickyHeight - ViewHeight.gccSearch) / 2 }

    static func make(in view: UIView, stickyHeight: CGFloat = 155) -> HomeHeaderLayout {
        let safeTop = view.window?.safeAreaInsets.top
            ?? UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first?.safeAreaInsets.top
            ?? 44
        return HomeHeaderLayout(statusBarHeight: safeTop, stickyHeight: stickyHeight)
    }
}
