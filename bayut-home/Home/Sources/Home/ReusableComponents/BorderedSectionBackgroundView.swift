//
//  BorderedSectionBackgroundView.swift
//  Home
//
//  Created by Hammad Shahid on 31/03/2026.
//

import UIKit

// MARK: - Bordered Background
final class BorderedSectionBackgroundView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.AppColors.grey2.cgColor
        layer.cornerRadius = 8
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
