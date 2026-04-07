//
//  BlogsGroup.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

final class BlogsGroup: SectionGroup {
    let groupId: String = "blogsGroup"
    let displayName: String = "From our Blog"
    let section: HomeSection? = .main
    
    private let title: String
    private let viewAllTitle: String
    private let blogs: [BlogData]
    private let actions: BlogsActions
    
    init(
        title: String,
        viewAllTitle: String,
        blogs: [BlogData],
        actions: BlogsActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.blogs = blogs
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        guard !blogs.isEmpty else { return [] }
        var sections: [AnySection] = []
        
        // 1. Title Header
        let titleSection = BlogsTitleSection(
            title: title,
            section: section
        )
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Blogs Carousel
        let carouselSection = BlogsCarouselSection(
            blogs: blogs,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Footer
        let viewAllSection = BlogsViewAllSection(
            buttonTitle: viewAllTitle,
            section: section,
            actions: actions
        )
        sections.append(AnySection(viewAllSection, isCustomizable: false))
        
        return sections
    }
}
