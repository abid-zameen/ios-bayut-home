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
    let beds: String?
    let baths: String?
    let area: Double?
    let isTruChecked: Bool
    let isChecked: Bool
    let verifiedAt: String?
    let imageURL: URL?
    let completionStatus: String?
    let handoverDate: NSAttributedString?
    let paymentPlanPercentage: NSAttributedString?
    let offPlanDetails: OffplanDetails?
    let ownerAgent: OwnerAgent?
    let price: Double?
    let purpose: Purpose?
    let rentFrequency: String?
    let paymentPlans: [PaymentPlan]?
    var isViewed: Bool = false
    var isContacted: Bool = false
    
    init(hit: AlgoliaPropertyHit) {
        self.id = hit.externalID ?? "\(hit.id ?? 0)"
        self.title = hit.title ?? ""
        
        // Handover
        if let completionDate = hit.completionDetails?.completionDateInt?.toDate() {
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
            .compactMap { $0.localizedName } ?? []
        
        self.location = locationNames.joined(separator: ", ")
        
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
            self.area = area * HomeConstants.SqmToSqftConversionRate
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
            let urlString = HomeModule.shared.environment.imageBaseUrl + "\(photoId)" + HomeConstants.imageDimension
            self.imageURL = URL(string: urlString)
        } else {
            self.imageURL = nil
        }
        
        isTruChecked = hit.isVerified && (hit.verification?.eligible ?? false)
        isChecked = hit.isVerified
        
        if let verifiedAt = hit.verification?.verifiedAt {
            let date = Date(timeIntervalSince1970: verifiedAt)
            let formatter = DateFormatter()
            formatter.dateFormat = date.dateFormatWithSuffix()
            self.verifiedAt = formatter.string(from: date)
        } else {
            self.verifiedAt = nil
        }
        
        completionStatus = hit.completionStatus
        offPlanDetails = hit.offplanDetails
        ownerAgent = hit.ownerAgent
        price = hit.price
        purpose = hit.purpose
        rentFrequency = hit.rentFrequency
        paymentPlans = hit.paymentPlans
    }
}
