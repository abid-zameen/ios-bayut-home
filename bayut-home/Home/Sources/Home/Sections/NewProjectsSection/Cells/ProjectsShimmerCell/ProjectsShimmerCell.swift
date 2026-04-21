//
//  ProjectsShimmerCell.swift
//  Home
//
//  Created by Hammad Shahid on 20/04/2026.
//

import UIKit

final class ProjectsShimmerCell: UICollectionViewCell {
    // MARK: - IBoutlets
    @IBOutlet private var shimmerViews: [UIView]?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

}

// MARK: - Setup
private extension ProjectsShimmerCell {
    func setupViews() {
        shimmerViews?.forEach( {
            $0.showShimmer()
        })
    }
}
