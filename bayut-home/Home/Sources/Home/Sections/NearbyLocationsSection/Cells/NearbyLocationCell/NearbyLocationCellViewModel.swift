//
//  NearbyLocationCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

protocol NearbyLocationCellViewModelType {
    var locationName: String { get }
    var locationDistance: String { get }
    var locationCity: String { get }
}

final class NearbyLocationCellViewModel: NearbyLocationCellViewModelType {
    
    var locationName: String
    var locationDistance: String
    var locationCity: String
    
    init(location: NearbyLocation) {
        self.locationName = location.name
        self.locationDistance = location.distance
        self.locationCity = location.city
    }
}
