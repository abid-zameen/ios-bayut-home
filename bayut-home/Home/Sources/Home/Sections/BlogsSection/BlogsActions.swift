//
//  BlogsActions.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import Foundation

protocol BlogsActionsDelegate: AnyObject {
    func blogsDidTapCard(with url: String?, title: String?)
    func blogsDidTapViewAll()
}

struct BlogsActions {
    weak var delegate: BlogsActionsDelegate?
}
