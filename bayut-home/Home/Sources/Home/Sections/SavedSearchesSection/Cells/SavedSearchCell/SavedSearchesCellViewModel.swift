//
//  SavedSearchesCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//
import UIKit

protocol SavedSearchesCellViewModelType {
    var title: String { get }
    var location: String { get }
    var searchName: String { get }
    var showIcon: Bool { get }
    var image: UIImage? { get }
}

final class SavedSearchesCellViewModel: SavedSearchesCellViewModelType {
    var title: String
    var location: String
    let searchName: String
    var showIcon: Bool
    var image: UIImage?
    
    init(search: SavedSearchesModel) {
        self.title = search.displayTitle
        self.location = search.location
        self.searchName = search.name
        self.showIcon = search.showIcon
        
        if let imageName = search.imageName {
            self.image = UIImage(named: imageName, in: .module, compatibleWith: nil)
        }
    }
}
