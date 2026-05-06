//
//  NearbyLocationsActions.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol NearbyLocationsActionsDelegate: AnyObject {
    func nearbyLocationsDidTapCard(at index: Int, with location: LocationHit)
    func nearbyLocationsDidTapAllowLocation()
}

final class NearbyLocationsActions {
    weak var delegate: NearbyLocationsActionsDelegate?
    
    init(delegate: NearbyLocationsActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
