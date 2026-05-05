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
    var price: NSAttributedString { get }
    var beds: String { get }
    var baths: String { get }
    var area: String { get }
    var location: String { get }
    var imageUrl: URL? { get }
    var property: Property { get }
    var isPropertyTruChecked: Bool { get }
    var showOffPlanInfo: Bool { get }
    var resaleLabelText: String { get }
    var showResaleInfo: Bool { get }
}

struct FavouriteCellViewModel: FavoritesCellViewModelType {
    var property: Property
    var id: String
    var title: String
    var price: NSAttributedString
    var beds: String
    var baths: String
    var area: String
    var location: String
    var imageUrl: URL?
    var isPropertyTruChecked: Bool
    var showOffPlanInfo: Bool
    var resaleLabelText: String = .empty
    var showResaleInfo: Bool = false
    
    init(property: Property) {
        self.property = property
        self.id = property.id
        self.title = property.title
        
        let attributedString = NSMutableAttributedString()
        let priceAttr: [NSAttributedString.Key: Any] = [.font: UIFont.headingL20]
        let priceString = HomeModule.shared.utilities.priceStringRepresentation(price: property.price) ?? "0"
        attributedString.append(NSAttributedString(string: priceString, attributes: priceAttr))
        
        if property.purpose == .rent, let frequency = property.rentFrequency {
            let freqAttr: [NSAttributedString.Key: Any] = [.font: UIFont.bodyL1]
            attributedString.append(NSAttributedString(string: " \(frequency.capitalized)", attributes: freqAttr))
        }
        
        self.price = attributedString
        
        self.beds = property.beds ?? .empty
        self.baths = property.baths ?? .empty
        self.area = Utils.getAreaFromSqft(area: property.area) ?? .empty
        self.location = property.location
        self.imageUrl = property.imageURL
        self.isPropertyTruChecked = property.isTruChecked
        self.showOffPlanInfo = property.completionStatus?.contains("under-construction") ?? false
        if let saleType = property.offPlanDetails?.saleType, !saleType.contains("direct_from_developer") {
            self.resaleLabelText = saleType == "new" ? "offplanNew".localized() : "resale".localized()
            self.showResaleInfo = true
        }
    }
}
