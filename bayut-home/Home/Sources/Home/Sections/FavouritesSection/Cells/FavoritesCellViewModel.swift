//
//  FavoritesCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//
import Foundation
import UIKit

protocol FavoritesCellViewModelType {
    var id: String { get }
    var title: String { get }
    var price: String { get }
    var beds: String { get }
    var baths: String { get }
    var area: String { get }
    var location: String { get }
    var imageUrl: URL? { get }
    var property: Property { get }
}

struct FavouriteCellViewModel: FavoritesCellViewModelType {
    var property: Property
    var id: String
    var title: String
    var price: String
    var beds: String
    var baths: String
    var area: String
    var location: String
    var imageUrl: URL?
    
    init(property: Property) {
        self.property = property
        self.id = property.id
        self.title = property.title
        self.price = property.price
        self.beds = property.beds ?? ""
        self.baths = property.baths ?? ""
        self.area = property.area ?? ""
        self.location = property.location
        self.imageUrl = property.imageURL
    }
}
