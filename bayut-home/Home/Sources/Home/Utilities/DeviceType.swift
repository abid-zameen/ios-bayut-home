//
//  DeviceType.swift
//  Home
//
//  Created by Hammad Shahid on 24/04/2026.
//

import UIKit

struct DeviceType {
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
    static var isLandScape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
}
