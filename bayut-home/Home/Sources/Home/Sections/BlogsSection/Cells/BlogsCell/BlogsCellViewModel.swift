//
//  BlogsCellViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//
import Foundation

protocol BlogsCellViewModelType {
    var title: String { get }
    var category: String { get }
    var image: URL? { get }
}

final class BlogsCellViewModel: BlogsCellViewModelType {
    var title: String
    var category: String
    var image: URL?
    
    init(blog: Blog) {
        self.title = blog.title
        
        var categories = ""
        if !blog.blogCategory.isEmpty {
            categories = blog.blogCategory.map { (category) -> String in
                return  category.title.uppercased()
            }.joined(separator: ", ")
        }
        self.category = categories
        
        self.image = URL(string: blog.imageUrl)
    }
}
