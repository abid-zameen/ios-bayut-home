//
//  NearbyLocationsActions.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol NearbyLocationsActionsDelegate: AnyObject {
    func nearbyLocationsDidTapCard(at index: Int)
    func nearbyLocationsDidTapAllowLocation()
}

struct NearbyLocationsActions {
    weak var delegate: NearbyLocationsActionsDelegate?
}
