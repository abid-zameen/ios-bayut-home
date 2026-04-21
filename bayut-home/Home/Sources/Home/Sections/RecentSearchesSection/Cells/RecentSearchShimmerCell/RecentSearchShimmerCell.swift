//
//  RecentSearchShimmerCell.swift
//  Home
//
//  Created by Hammad Shahid on 20/04/2026.
//

import UIKit

final class RecentSearchShimmerCell: UICollectionViewCell {
    // MARK: - IBoutlets
    @IBOutlet private var shimmerViews: [UIView]?
    @IBOutlet private weak var containerView: UIView?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Setup
private extension RecentSearchShimmerCell {
    func setupViews() {
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        
        containerView?.backgroundColor = .white
        containerView?.layer.cornerRadius = 12
        containerView?.clipsToBounds = false
        
        containerView?.sketchShadow(
            shadowColor: UIColor.black,
            height: 2,
            shadowOpacity: 0.08,
            shadowRadius: 6
        )
        
        shimmerViews?.forEach( {
            $0.showShimmer()
        })
    }
}
