//
//  SavedSearchesCell.swift
//  Home
//
//  Created by Hammad Shahid on 02/04/2026.
//

import UIKit
import UIToolKit

final class SavedSearchesCell: HighlightableCollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var searchNameLabel: UILabel?
    @IBOutlet private weak var locationsLabel: UILabel?
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var cellBackgroundView: UIView?
    
    // MARK: - Properties
    var viewModel: SavedSearchesCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? SavedSearchesCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
}

// MARK: - Setup
private extension SavedSearchesCell {
    func setupViews() {
        titleLabel?.textColor = UIColor.teal5
        titleLabel?.font = UIFont.boldBody
        
        searchNameLabel?.textColor = UIColor.blackTextColor
        searchNameLabel?.font = UIFont.appBoldFont(ofSize: 16)
        
        locationsLabel?.textColor = UIColor.grey5
        locationsLabel?.font = UIFont.body
        
        cellBackgroundView?.setBorder(UIColor.grey2, width: 1)
        cellBackgroundView?.setRoundedCorner(radius: 8)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        titleLabel?.text = viewModel.title
        searchNameLabel?.text = viewModel.searchName
        locationsLabel?.text = viewModel.location
        imageView.image = viewModel.image
        imageView.isHidden = !viewModel.showIcon
    }
}

