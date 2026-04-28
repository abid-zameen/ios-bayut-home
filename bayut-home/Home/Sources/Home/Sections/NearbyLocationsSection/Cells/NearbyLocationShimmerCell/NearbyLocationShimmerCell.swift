//
//  NearbyLocationShimmerCell.swift
//  Home
//
//  Created by Hammad Shahid on 20/04/2026.
//

import UIKit

final class NearbyLocationShimmerCell: UICollectionViewCell {
    // MARK: - IBoutlets
    @IBOutlet private var shimmerViews: [UIView]?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

}

// MARK: - Setup
private extension NearbyLocationShimmerCell {
    func setupViews() {
        contentView.setBorder(UIColor.grey2, width: 1)
        contentView.setRoundedCorner(radius: 8)
        
        shimmerViews?.forEach( {
            $0.showShimmer()
        })
    }
}
