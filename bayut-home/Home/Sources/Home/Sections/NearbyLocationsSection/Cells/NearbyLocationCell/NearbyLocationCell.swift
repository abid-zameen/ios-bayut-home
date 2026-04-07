//
//  NearbyLocationCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit

final class NearbyLocationCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var cityLabel: UILabel?
    @IBOutlet private weak var distanceLabel: UILabel?
    @IBOutlet private weak var mainStackView: UIStackView?
    
    // MARK: - Properties
    private var viewModel: NearbyLocationCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? NearbyLocationCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
}

// MARK: - Setup
private extension NearbyLocationCell {
    func setupViews() {
        nameLabel?.textColor = UIColor.AppColors.teal5
        nameLabel?.font = UIFont.boldBody
        
        cityLabel?.textColor = UIColor.AppColors.grey5
        cityLabel?.font = UIFont.body
        
        distanceLabel?.textColor = UIColor.AppColors.grey7
        distanceLabel?.font = UIFont.body
        
        contentView.setBorder(UIColor.AppColors.grey2, width: 1)
        contentView.setRoundedCorner(radius: 8)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        nameLabel?.text = viewModel.locationName
        cityLabel?.text = viewModel.locationCity
        distanceLabel?.text = viewModel.locationDistance
    }
}
