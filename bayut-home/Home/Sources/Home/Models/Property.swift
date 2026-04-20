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
    let isTruChecked: Bool
    let imageURL: URL?
    let completionStatus: String?
    let handoverDate: NSAttributedString?
    let paymentPlanPercentage: NSAttributedString?
    let offPlanDetails: OffplanDetails?
    let ownerAgent: OwnerAgent?
    let rawPrice: Double?
    let purpose: Purpose?
    let rentFrequency: String?
    
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
            let pre = Int(paymentPlan.preHandoverPercentageSum ?? 0.0)
            let post = Int(paymentPlan.postHandoverPercentageSum ?? 0.0)
            let value = "\(pre)/\(post)"
            self.paymentPlanPercentage = (pre > 0 && post > 0) ? "\(title): \(value)".makeBold(text: value, font: .boldBodyS1) : nil
        } else {
            self.paymentPlanPercentage = nil
        }
        
        let locationNames = hit.location?
            .filter { ($0.level ?? 0) > 0 }
            .sorted(by: { ($0.level ?? 0) > ($1.level ?? 0) })
            .compactMap { $0.name } ?? []
        
        self.location = locationNames.joined(separator: ", ")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: hit.price ?? 0)) ?? "0"
        
        if hit.purpose == .rent, let frequency = hit.rentFrequency {
            self.price = "\(formattedPrice) AED / \(frequency.capitalized)"
        } else {
            self.price = "\(formattedPrice) AED"
        }
        
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
        
        isTruChecked = hit.isVerified && (hit.verification?.eligible ?? false)
        completionStatus = hit.completionStatus
        offPlanDetails = hit.offplanDetails
        ownerAgent = hit.ownerAgent
        rawPrice = hit.price
        purpose = hit.purpose
        rentFrequency = hit.rentFrequency
    }
}
