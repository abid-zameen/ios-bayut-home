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
    
    init(hit: ProjectHit, showWhatsappButton: Bool) {
        self.id = hit.externalID ?? hit.objectID
        self.title = hit.title ?? ""
        self.type = hit.unitCategories?.first?.last?.name ?? "Project"
        
        let locationNames = hit.location?
            .filter { ($0.level ?? 0) > 0 }
            .sorted(by: { ($0.level ?? 0) > ($1.level ?? 0) })
            .compactMap { $0.name } ?? []
        
        self.location = locationNames.joined(separator: ", ")
        
        if let price = hit.price, price > 0 {
            self.startingPrice = Utils.priceShortStringRepresentationWithoutDecimal(price: price)
        } else {
            self.startingPrice = nil
        }
        
        if let completionDate = hit.completionDetails?.completionDate {
            let date = Date(timeIntervalSince1970: completionDate)
            if NewProjectCellViewModel.isInCurrentOrFutureQuarter(date: date) {
                self.handoverValue = NewProjectCellViewModel.getHandoverDate(date: date)
            } else {
                self.handoverValue = nil
            }
        } else {
            self.handoverValue = nil
        }
        
        if let photoID = hit.coverPhoto?.id {
            let imageBase = HomeModule.shared.environment.imageBaseUrl
            let urlString = "\(imageBase)\(photoID)" + HomeConstants.imageDimension
            self.imageURL = URL(string: urlString)
        } else {
            self.imageURL = nil
        }
        
        self.showWhatsappButton = showWhatsappButton
    }
    
    private static func getHandoverDate(date: Date) -> String {
        return "Q\(date.quarter) \(date.yearInt)"
    }
    
    private static func isInCurrentOrFutureQuarter(date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        let inputYear = date.yearInt
        let inputQuarter = date.quarter

        let currentYear = now.yearInt
        let currentQuarter = now.quarter

        if inputYear > currentYear {
            return true
        } else if inputYear == currentYear {
            return inputQuarter >= currentQuarter
        } else {
            return false
        }
    }
}
