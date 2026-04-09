//
//  Property.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import Foundation

struct Property: Hashable {
    let id: String
    let title: String
    let location: String
    let price: String
    let beds: String?
    let baths: String?
    let area: String?
    let imageURL: URL?
    let handoverDate: NSAttributedString?
    let paymentPlanPercentage: NSAttributedString?
    
    init(hit: AlgoliaPropertyHit) {
        self.id = hit.externalID ?? "\(hit.id ?? 0)"
        self.title = hit.title ?? ""
        
        // Handover
        if let completionDate = hit.completionDetails?.completionDateInt?.convertToDate() {
            let handoverText = "Handover" 
            let dateString = "Q\(completionDate.quarter) \(completionDate.yearInt)"
            self.handoverDate = "\(handoverText): \(dateString)".makeBold(text: dateString, font: .boldBodyS1)
        } else {
            self.handoverDate = nil
        }
        
        // Payment Plan
        if let paymentPlan = hit.paymentPlans?.first {
            let title = "Payment Plan"
            let pre = Int(paymentPlan.preHandoverSum ?? paymentPlan.preHandOverPercentageSum ?? 0.0)
            let post = Int(paymentPlan.postHandoverSum ?? paymentPlan.postHandOverPercentageSum ?? 0.0)
            let value = "\(pre)/\(post)"
            self.paymentPlanPercentage = "\(title): \(value)".makeBold(text: value, font: .boldBodyS1)
        } else {
            self.paymentPlanPercentage = nil
        }
        
        // 1. Location Breadcrumb (Level 3, Level 2)
        let locationNames = hit.location?
            .sorted(by: { ($0.level ?? 0) > ($1.level ?? 0) }) // Sort by specificity
            .compactMap { $0.name } ?? []
        
        // In Algolia hits, level 3 is often more specific than level 2
        // We'll join the first two most specific ones for the card
        self.location = Array(locationNames.prefix(2)).reversed().joined(separator: ", ")
        
        // 2. Price Formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: hit.price ?? 0)) ?? "0"
        
        if hit.purpose == .rent, let frequency = hit.rentFrequency {
            self.price = "\(formattedPrice) AED / \(frequency.capitalized)"
        } else {
            self.price = "\(formattedPrice) AED"
        }
        
        // 3. Rooms/Beds
        if let rooms = hit.rooms {
            if rooms == 0 {
                self.beds = "Studio"
            } else {
                self.beds = "\(rooms) Beds"
            }
        } else {
            self.beds = nil
        }
        
        // 4. Baths
        if let baths = hit.baths {
            self.baths = "\(baths) Baths"
        } else {
            self.baths = nil
        }
        
        // 5. Area
        if let area = hit.area {
            self.area = "\(Int(round(area))) sqft"
        } else {
            self.area = nil
        }
        
        let photoId: Int?
        if let numericId = hit.coverPhoto?.id, numericId != 0 {
            photoId = numericId
        } else if let extIdString = hit.coverPhoto?.externalID, let extId = Int(extIdString), extId != 0 {
            photoId = extId
        } else {
            photoId = nil
        }
        
        if let photoId {
            let urlString = HomeModule.shared.environment.imageBaseUrl + "\(photoId)-400x300.jpeg"
            self.imageURL = URL(string: urlString)
        } else {
            self.imageURL = nil
        }
    }
}
