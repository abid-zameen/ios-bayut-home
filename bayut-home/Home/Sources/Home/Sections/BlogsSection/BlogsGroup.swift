//
//  BlogsGroup.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

final class BlogsGroup: SectionGroup {
    let groupId: String = "blogsGroup"
    let displayName: String = "fromOurBlogs".localized()
    let section: HomeSection? = .main
    
    private let title: String
    private let viewAllTitle: String
    private let blogs: Home.DataState<[Blog]>
    private let actions: BlogsActions
    
    init(
        title: String,
        viewAllTitle: String,
        blogs: Home.DataState<[Blog]>,
        actions: BlogsActions
    ) {
        self.title = title
        self.viewAllTitle = viewAllTitle
        self.blogs = blogs
        self.actions = actions
    }
    
    func buildSections() -> [AnySection] {
        var sections: [AnySection] = []
        
        if case .empty = blogs {
            return []
        }
        
        // 1. Title Header
        let titleSection = BlogsTitleSection(title: title, section: section)
        sections.append(AnySection(titleSection, isCustomizable: false))
        
        // 2. Carousel Section (Handles loading/data internally)
        let carouselSection = BlogsCarouselSection(
            state: blogs,
            section: section,
            actions: actions
        )
        sections.append(AnySection(carouselSection, isCustomizable: false))
        
        // 3. View All Section (Only if data is present)
        if case .data(let items) = blogs, !items.isEmpty {
            let viewAllSection = BlogsViewAllSection(
                buttonTitle: viewAllTitle,
                section: section,
                actions: actions
            )
            sections.append(AnySection(viewAllSection, isCustomizable: false))
        }
        
        return sections
    }
}
