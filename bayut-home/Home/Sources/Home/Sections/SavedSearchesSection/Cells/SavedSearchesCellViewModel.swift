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
    var image: UIImage? { get }
}

final class SavedSearchesCellViewModel: SavedSearchesCellViewModelType {
    var title: String
    var location: String
    let searchName: String
    var image: UIImage?
    
    init(search: SavedSearchesModel) {
        self.title = search.title
        self.location = search.location
        self.searchName = search.searchName
        self.image = UIImage(named:search.image, in: .module, compatibleWith: nil)
    }
}
