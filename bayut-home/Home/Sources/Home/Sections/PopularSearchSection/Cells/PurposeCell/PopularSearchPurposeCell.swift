//
//  PopularSearchPurposeCell.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

final class PopularSearchPurposeCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel?
    
    // MARK: - Properties
    private var viewModel: PopularSearchPurposeCellViewModelType?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? PopularSearchPurposeCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
}

private extension PopularSearchPurposeCell {
    func setupViews() {
        titleLabel?.font = .bodyL0
        titleLabel?.textColor = .AppColors.grey5
        contentView.setRoundedCorner(radius: 4)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        titleLabel?.text = viewModel.title
        titleLabel?.font = viewModel.isSelected ? .headingL4 : .bodyL0
        titleLabel?.textColor = viewModel.isSelected ? .AppColors.green5 : .AppColors.grey5
        contentView.backgroundColor = viewModel.isSelected ? .AppColors.green1 : .clear
        contentView.setBorder(viewModel.isSelected ? .AppColors.green1 : .AppColors.grey2, width: 1)
    }
}
