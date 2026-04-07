//
//  PopularSearchPurposeCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

protocol PopularSearchPurposeCellViewModelType {
    var title: String { get }
    var isSelected: Bool { get }
}

final class PopularSearchPurposeCellViewModel: PopularSearchPurposeCellViewModelType {
    let title: String
    let isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}
