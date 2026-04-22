//
//  SellerLeadsBannerCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class SellerLeadsBannerCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var mainView: UIView?
    @IBOutlet private weak var parentView: UIView?
    @IBOutlet private weak var backgroundImage: UIImageView?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var readyToSellHomeTitle: UILabel?
    @IBOutlet private weak var newBadgeView: UIView?
    @IBOutlet private weak var triangle3dImage: UIImageView?
    @IBOutlet private weak var newLabel: UILabel?
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "seller-leads-banner-image"
        static let readyToSellHomeTitle = "ready_to_sell_or_rent".localized()
        static let descriptionText = "share_your_details".localized()
        static let new = "new".localized()
        static let triangleImage = "triangle-vector"

        static let gradientColor1: UIColor = .AppColors.forestGreenTeal
        static let gradientColor2: UIColor = .AppColors.mediumForestTeal
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradients()
    }

    func updateGradients() {
        parentView?.layoutIfNeeded()
        parentView?.updateGradientLayerFrame()
    }

}

private extension SellerLeadsBannerCell {
    func setupViews() {
        backgroundImage?.image = UIImage(named: Constants.backgroundImage, in: .module, compatibleWith: nil)
        backgroundImage?.contentMode = .scaleAspectFit
        
        parentView?.setRoundedCorner(radius: 8)
        parentView?.setGradient(
            colors: [Constants.gradientColor1.cgColor, Constants.gradientColor2.cgColor],
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5),
            locations: [0, 0.75]
        )
        
        readyToSellHomeTitle?.text = Constants.readyToSellHomeTitle
        readyToSellHomeTitle?.textColor = UIColor.AppColors.limeGreenColor
        readyToSellHomeTitle?.font = .heading
        readyToSellHomeTitle?.setContentCompressionResistancePriority(.required, for: .vertical)
        
        descriptionLabel?.text = Constants.descriptionText
        descriptionLabel?.textColor = .white
        descriptionLabel?.font = .body
        descriptionLabel?.add(lineHeight: 1.25, alignment: .natural, lineBreakMode: .byTruncatingTail)
        descriptionLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let bottomEdgeMask: CACornerMask = "language" == "arabic" ? .layerMaxXMaxYCorner : .layerMinXMaxYCorner
        newBadgeView?.setRoundedCorner(radius: (newBadgeView?.frame.height ?? 1) / 2, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, bottomEdgeMask])
        newBadgeView?.backgroundColor = .AppColors.secondaryRedColor
        newLabel?.textColor = .white
        newLabel?.font = .headingS1
        newLabel?.text = Constants.new
        triangle3dImage?.image = UIImage(named: Constants.triangleImage, in: .module, compatibleWith: nil)
        
        mainView?.isUserInteractionEnabled = true
        //mainView?.addTapGesture(target: self, selector: #selector(handleTap))
        
//        parentView?.setSemanticContentAttribute()
//        mainView?.setSemanticContentAttribute()
//        triangle3dImage?.localize()
//        backgroundImage?.localize()
    }
}
