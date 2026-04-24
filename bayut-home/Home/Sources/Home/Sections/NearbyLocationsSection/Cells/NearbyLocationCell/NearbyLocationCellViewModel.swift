//
//  NearbyLocationCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import CoreLocation

protocol NearbyLocationCellViewModelType {
    var locationName: String { get }
    var locationDistance: String { get }
    var locationCity: String { get }
    var location: LocationHit { get }
}

final class NearbyLocationCellViewModel: NearbyLocationCellViewModelType {
    
    var locationName: String
    var locationDistance: String
    var locationCity: String
    let location: LocationHit
    
    init(location: LocationHit) {
        self.location = location
        self.locationName = location.localizedName
        self.locationCity = location.hierarchy?.first(where: { $0.level == 1 })?.localizedName ?? ""
        self.locationDistance = Self.distanceString(for: location)
    }
    
    private static func distanceString(for location: LocationHit) -> String {
        guard let userCoordinates = HomeModule.shared.environment.userCoordinates,
              let geo = location.geography else {
            return ""
        }
        
        let userLocation = CLLocation(latitude: userCoordinates.lat, longitude: userCoordinates.lon)
        let targetLocation = CLLocation(latitude: geo.lat, longitude: geo.lng)
        let distance = userLocation.distance(from: targetLocation)
        
        if distance >= 1000 {
            let km = Int(round(distance / 1000.0))
            return "\(km) km"
        } else {
            let meters = Int(round(distance))
            return "\(meters) m"
        }
    }
}
