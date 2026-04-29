//
//  MapCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit
import BayutUIKit

final class MapCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var titleTextLabel: UILabel?
    @IBOutlet private weak var allowLocationCTA: PrimaryDarkButton?
    
    // MARK: - Properties
    private var viewModel: MapCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? MapCellViewModelType else { return }
        self.viewModel = viewModel
    }
    
    // MARK: - Actions
    @IBAction private func tappedAllowLocation(_ sender: Any) {
        viewModel?.onAllowLocationAccessTapped?()
    }
}

private extension MapCell {
    func setupViews() {
        titleTextLabel?.text = "Enable your location to get tailored nearby locations"
        titleTextLabel?.font = .body
        allowLocationCTA?.setTitle("Allow Location Access", for: .normal)
        allowLocationCTA?.setupTealColors()
        contentView.setBorder(.grey1, width: .standardBorderWidth)
        contentView.setRoundedCorner(radius: .extraSmall)
    }
}
