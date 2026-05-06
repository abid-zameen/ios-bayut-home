//
//  BlogsActions.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol BlogsActionsDelegate: AnyObject {
    func blogsDidTapCard(at index: Int, with url: String?, title: String?)
    func blogsDidTapViewAll()
}

final class BlogsActions {
    weak var delegate: BlogsActionsDelegate?
    
    init(delegate: BlogsActionsDelegate? = nil) {
        self.delegate = delegate
    }
}
