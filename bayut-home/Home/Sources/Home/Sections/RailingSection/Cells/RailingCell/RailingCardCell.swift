//
//  RailingCardCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit
import BayutUIKit

final class RailingCardCell: HighlightableCollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var mainContentView: UIView?
    @IBOutlet private weak var headingLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var ctaButton: UIButton?
    @IBOutlet private weak var ctalabel: UILabel?
    @IBOutlet private weak var ctaView: UIView?
    @IBOutlet private weak var backgroundImageView: UIImageView?
    @IBOutlet private weak var itemImageView: UIImageView?
    
    // MARK: - Properties
    private var viewModel: RailingCardCellViewModelType?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? RailingCardCellViewModel else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
    
    // MARK: - Actions
    
    @IBAction private func ctaAction(_ sender: Any) {
        viewModel?.onCTATap?()
    }
}

private extension RailingCardCell {
    func setupViews() {
        self.clipsToBounds = false
        contentView.backgroundColor = .white
        contentView.setRoundedCorner(radius: .extraSmall)
        contentView.clipsToBounds = false
        contentView.sketchShadow()
        
        mainContentView?.setRoundedCorner(radius: .extraSmall)
        mainContentView?.clipsToBounds = true
        
        headingLabel?.font = UIFont.headingL1
        headingLabel?.textColor = UIColor.blackTextColor
        
        descriptionLabel?.textColor = UIColor.blackTextColor
        descriptionLabel?.font = UIFont.body
        
        ctalabel?.font = .heading
        ctalabel?.textColor = .turquoiseColor
        ctaView?.backgroundColor = .white
        ctaView?.setRoundedCorner(radius: .extraSmall)
        ctaButton?.setTitle(.empty, for: .normal)
    }
    
    func setupWithViewModel() {
        guard let viewModel = viewModel else { return }
        
        headingLabel?.text = viewModel.headingText
        descriptionLabel?.text = viewModel.descriptionText
        ctalabel?.text = viewModel.ctaText
        mainContentView?.backgroundColor = viewModel.backgroundViewColor
        
        if let bgImageName = viewModel.backgroundImage {
            backgroundImageView?.image = UIImage(named: bgImageName, in: .module, compatibleWith: nil)
            backgroundImageView?.isHidden = false
        } else {
            backgroundImageView?.image = nil
            backgroundImageView?.isHidden = true
        }
        
        itemImageView?.image = UIImage(named: viewModel.itemImage, in: .module, compatibleWith: nil)
    }
}
