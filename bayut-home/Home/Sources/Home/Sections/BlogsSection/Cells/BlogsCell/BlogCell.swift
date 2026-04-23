//
//  BlogCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit

final class BlogCell: HighlightableCollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var blogTitleLabel: UILabel?
    @IBOutlet private weak var categoryLabel: UILabel?
    @IBOutlet private weak var blogImageView: UIImageView?
    
    // MARK: - Properties
    private var viewModel: BlogsCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? BlogsCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
}

private extension BlogCell {
    func setupViews() {
        blogTitleLabel?.textColor = UIColor.AppColors.blackTextColor
        blogTitleLabel?.font = UIFont.bodyL1
        
        categoryLabel?.textColor = UIColor.AppColors.teal5
        categoryLabel?.font = UIFont.boldBody
        
        contentView.setBorder(UIColor.AppColors.grey2, width: 1)
        contentView.setRoundedCorner(radius: 8)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        blogTitleLabel?.text = viewModel.title
        categoryLabel?.text = viewModel.category
        blogImageView?.loadImage(with: viewModel.image)
    }
}
