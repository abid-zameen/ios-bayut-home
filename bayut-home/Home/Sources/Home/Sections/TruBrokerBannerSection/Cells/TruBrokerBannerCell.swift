//
//  TruBrokerBannerCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class TruBrokerBannerCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mainContentView: UIView?
    @IBOutlet private weak var backgroundImage: UIImageView?
    @IBOutlet private weak var truBrokerBadgeView: UIView?
    @IBOutlet private weak var headingLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var arrowImage: UIImageView?
    @IBOutlet private weak var newView: UIView?
    @IBOutlet private weak var newLabel: UILabel?
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "truBroker_entry_bg"
        static let descriptionText = "findVerifiedAgents".localized()
        static let headingText = "truBroker".localized()
        static let new = "new".localized()
        static let arrowImage = "icon_right_arrow_white"
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Setup
private extension TruBrokerBannerCell {
    func setupViews() {
        mainContentView?.setRoundedCorner(radius: 8)
        
        backgroundImage?.image = "language" == "arabic" ? UIImage(named: Constants.backgroundImage, in: .module, compatibleWith: nil)?.imageFlippedForRightToLeftLayoutDirection() : UIImage(named: Constants.backgroundImage, in: .module, compatibleWith: nil)
        
        truBrokerBadgeView?.clipsToBounds = false
        truBrokerBadgeView?.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        truBrokerBadgeView?.layer.shadowOpacity = 1
        truBrokerBadgeView?.layer.shadowRadius = 16.7
        truBrokerBadgeView?.layer.shadowOffset = CGSize(width: -4, height: 0)
        truBrokerBadgeView?.layer.masksToBounds = false
        
        headingLabel?.font = UIFont.body
        headingLabel?.text = Constants.headingText
        headingLabel?.textColor = UIColor.white
        headingLabel?.highlight(text: "broker".localized(), font: UIFont.headingL4)
        
        descriptionLabel?.text = Constants.descriptionText
        descriptionLabel?.font = UIFont.body
        descriptionLabel?.add(lineHeight: 1.25, alignment: "language" == "arabic" ? .right : .left, lineBreakMode: .byWordWrapping)
        
        arrowImage?.image = "language" == "arabic" ? UIImage(named: Constants.arrowImage, in: .module, compatibleWith: nil)?.imageFlippedForRightToLeftLayoutDirection() : UIImage(named: Constants.arrowImage, in: .module, compatibleWith: nil)
        
        newView?.backgroundColor = UIColor.AppColors.secondaryRedColor
        newView?.setRoundedWithRespectToHeight()
        
        newLabel?.textColor = UIColor.white
        newLabel?.font = UIFont.appBoldFont(ofSize: 8.92)
        newLabel?.text = Constants.new
    }
}
