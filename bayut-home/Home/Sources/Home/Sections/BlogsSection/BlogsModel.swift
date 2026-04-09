//
//  BlogsModel.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

struct Blog: Codable {
    let blogPostId: Int
    let title: String
    let imageUrl: String
    let blogUrl: String
    let blogCategory: [BlogCategory]
    
    enum CodingKeys: String, CodingKey {
        case blogPostId = "post_id"
        case title
        case imageUrl = "image"
        case blogUrl = "url"
        case blogCategory = "categories"
    }
}

struct BlogCategory: Codable {
    let categoryId: Int
    let title: String
    let slug: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case title
        case slug
    }
}
