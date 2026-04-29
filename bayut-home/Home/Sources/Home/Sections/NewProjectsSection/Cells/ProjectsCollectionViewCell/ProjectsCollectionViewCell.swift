//
//  ProjectsViewCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit
import BayutUIKit

final class ProjectsCollectionViewCell: HighlightableCollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var launchPriceTitle: UILabel?
    @IBOutlet private weak var handOverTitle: UILabel?
    @IBOutlet private weak var dividerView: UIView?
    @IBOutlet private weak var handOverPriceView: UIView?
    @IBOutlet private weak var launchPriceView: UIView?
    @IBOutlet private weak var whatsappButton: WhatsappButton?
    @IBOutlet private weak var handOverValue: UILabel?
    @IBOutlet private weak var bottomView: UIView?
    @IBOutlet private weak var projectLocation: UILabel?
    @IBOutlet private weak var startingPrice: UILabel?
    @IBOutlet private weak var locationProjectIcon: UIImageView?
    @IBOutlet private weak var projectType: UILabel?
    @IBOutlet private weak var projectName: UILabel?
    @IBOutlet private weak var projectImage: UIImageView?
    
    // MARK: - Constants
    private enum Constants {
        static let handover = "handover".localized()
        static let startingFromTitle = "startingFromTitle".localized()
        static let whatsApp = "whatsApp".localized()
    }
    
    // MARK: - Properties
    var viewModel: NewProjectCellViewModelType?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? NewProjectCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
    
    @IBAction private func whatsappAction(_ sender: Any) {
        
    }
}

private extension ProjectsCollectionViewCell {
    func setupViews() {
        contentView.clipsToBounds = false
        bottomView?.layer.cornerRadius = .extraSmall
        projectImage?.layer.cornerRadius = .extraSmall
        projectImage?.clipsToBounds = true
        
        handOverTitle?.text = Constants.handover
        launchPriceTitle?.text = Constants.startingFromTitle
        
        whatsappButton?.setTitle(Constants.whatsApp, for: .normal)
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        
        projectName?.text = viewModel.title
        projectType?.text = viewModel.type
        projectLocation?.text = viewModel.location
        handOverValue?.text = viewModel.handoverValue
        handOverPriceView?.isHidden = viewModel.handoverValue == nil
        
        if let price = viewModel.startingPrice, !price.isEmpty {
            startingPrice?.text = price
            launchPriceView?.isHidden = false
            dividerView?.isHidden = false
        } else {
            launchPriceView?.isHidden = true
            dividerView?.isHidden = true
        }
        
        if let url = viewModel.imageURL {
            projectImage?.loadImage(with: url)
        }
        
        whatsappButton?.isHidden = !viewModel.showWhatsappButton
    }
}
