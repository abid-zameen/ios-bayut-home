//
//  RailingCardCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class RailingCardCell: UICollectionViewCell {
    
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
}

private extension RailingCardCell {
    func setupViews() {
        mainContentView?.backgroundColor = .white
        mainContentView?.setRoundedCorner(radius: 8)
        mainContentView?.clipsToBounds = true
        mainContentView?.sketchShadow()
        
        headingLabel?.font = UIFont.headingL1
        headingLabel?.textColor = UIColor.AppColors.blackTextColor
        
        descriptionLabel?.textColor = UIColor.AppColors.blackTextColor
        descriptionLabel?.font = UIFont.body
        
        ctalabel?.font = .heading
        ctalabel?.textColor = .AppColors.turquoiseColor
        ctaView?.backgroundColor = .white
        ctaView?.setRoundedCorner(radius: 8)
        ctaButton?.setTitle("", for: .normal)
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
