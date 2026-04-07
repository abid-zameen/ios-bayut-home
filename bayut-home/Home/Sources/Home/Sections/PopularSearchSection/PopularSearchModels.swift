//
//  PopularSearchModels.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import Foundation

enum PopularSearchPurpose: String, CaseIterable {
    case buy = "Buy"
    case rent = "Rent"
    case dailyRental = "Daily Rental"
}

struct PopularSearch: Hashable {
    let title: String
    let location: String
    let iconName: String
}
