//
//  ProjectsCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol NewProjectCellViewModelType: AnyObject {
    var id: String { get }
    var title: String { get }
    var type: String { get }
    var location: String { get }
    var startingPrice: String? { get }
    var handoverValue: String? { get }
    var imageURL: URL? { get }
    var showWhatsappButton: Bool { get }
}

final class NewProjectCellViewModel: NewProjectCellViewModelType {
    let id: String
    let title: String
    let type: String
    let location: String
    let startingPrice: String?
    let handoverValue: String?
    let imageURL: URL?
    let showWhatsappButton: Bool
    
    init(hit: ProjectHit) {
        self.id = hit.externalID ?? hit.objectID
        self.title = hit.title ?? ""
        self.type = hit.unitCategories?.first?.last?.name ?? "Project"
        self.location = hit.location?.compactMap { $0.name }.joined(separator: ", ") ?? ""
        
        if let price = hit.price, price > 0 {
            if price >= 1_000_000 {
                self.startingPrice = String(format: "AED %.1fM", price / 1_000_000)
            } else if price >= 1_000 {
                self.startingPrice = String(format: "AED %.0fK", price / 1_000)
            } else {
                self.startingPrice = String(format: "AED %.0f", price)
            }
        } else {
            self.startingPrice = nil
        }
        
        if let completionDate = hit.completionDetails?.completionDate {
            let date = Date(timeIntervalSince1970: completionDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            self.handoverValue = formatter.string(from: date)
        } else {
            self.handoverValue = nil
        }
        
        if let photoID = hit.coverPhoto?.id {
            let imageBase = HomeModule.shared.environment.imageBaseUrl
            let urlString = "\(imageBase)\(photoID)-240x180.jpeg"
            self.imageURL = URL(string: urlString)
        } else {
            self.imageURL = nil
        }
        
        self.showWhatsappButton = true
    }
}
