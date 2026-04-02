//
//  BlogsCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

protocol BlogsCellViewModelType {
    var title: String { get }
    var category: String { get }
    var image: String { get }
}

final class BlogsCellViewModel: BlogsCellViewModelType {
    var title: String
    var category: String
    var image: String
    
    init(blog: BlogData) {
        self.title = blog.title
        self.category = blog.category
        self.image = blog.image
    }
}
