//
//  NearbyLocationCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit
import BayutUIKit

final class NearbyLocationCell: HighlightableCollectionViewCell {
    
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
        nameLabel?.textColor = UIColor.teal5
        nameLabel?.font = UIFont.boldBody
        
        cityLabel?.textColor = UIColor.grey5
        cityLabel?.font = UIFont.body
        
        distanceLabel?.textColor = UIColor.grey7
        distanceLabel?.font = UIFont.body
        
        contentView.setBorder(UIColor.grey2, width: .standardBorderWidth)
        contentView.setRoundedCorner(radius: .extraSmall)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        nameLabel?.text = viewModel.locationName
        cityLabel?.text = viewModel.locationCity
        distanceLabel?.text = viewModel.locationDistance
    }
}
