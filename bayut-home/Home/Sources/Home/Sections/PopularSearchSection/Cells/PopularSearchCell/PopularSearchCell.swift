//
//  PopularSearchCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit
import BayutUIKit

final class PopularSearchCell: HighlightableCollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var contentStackView: UIStackView?
    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var locationLabel: UILabel?
    
    // MARK: - Properties
    private var viewModel: PopularSearchCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? PopularSearchCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
    
    override func prepareForReuse() {
        self.viewModel = nil
        self.locationLabel?.text = ""
    }

}

private extension PopularSearchCell {
    func setupViews() {
        titleLabel?.font = .headingL4
        titleLabel?.textColor = .teal5
        
        locationLabel?.font = .bodyL0
        locationLabel?.textColor = .grey7
        
        contentView.setRoundedCorner(radius: 8)
        contentView.setBorder(.grey2, width: 1)
        contentView.backgroundColor = .white
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        titleLabel?.text = viewModel.title
        locationLabel?.text = viewModel.location
        iconImageView?.image = viewModel.icon
    }
}
