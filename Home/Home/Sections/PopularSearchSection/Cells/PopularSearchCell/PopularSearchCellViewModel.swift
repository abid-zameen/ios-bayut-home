//
//  PopularSearchCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

protocol PopularSearchCellViewModelType {
    var title: String { get }
    var location: String { get }
    var icon: UIImage? { get }
}

final class PopularSearchCellViewModel: PopularSearchCellViewModelType {
    let title: String
    let location: String
    let icon: UIImage?
    
    init(search: PopularSearch) {
        self.title = search.title
        self.location = search.location
        self.icon = UIImage(named: search.iconName)
    }
}
