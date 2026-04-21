//
//  BlogsShimmerCell.swift
//  Home
//
//  Created by Hammad Shahid on 20/04/2026.
//

import UIKit

final class BlogsShimmerCell: UICollectionViewCell {
    @IBOutlet private var shimmerViews: [UIView] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

}
private extension BlogsShimmerCell {
    func setupViews() {
        shimmerViews.forEach( {
            $0.showShimmer()
        })
    }
}
