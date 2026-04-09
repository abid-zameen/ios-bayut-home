//
//  PropertyBadgeView.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//

import UIKit

enum ProductStatus {
    case hot
    case developerRed
    case signature
    case developerBlue
    case developerGray
    case developerInserted
    case none
}

enum PropertyBadgeType {
    case status(ProductStatus)
    case booked
}

final class PropertyBadgeView: BadgeViewGeneric {
    
    private enum Constants {
        static let hotIcon = "hot_icon"
        static let signatureIcon = "signature_icon"
        static let bookedIcon = "booked-until-calender-tick"
        static let hotButtonTitle = " \("hot".localized()) "
        static let signatureButtonTitle = " \("signature".localized()) "
        static let bookedText = "booked".localized()
        static let developerLabel = "developerLabel".localized()
    }
    
    // MARK: - Properties
    private var gradientLayer = CAGradientLayer()
    
    // MARK: - Public API
    func configure(with type: PropertyBadgeType) {
        resetView()
        
        switch type {
        case .status(let status):
            setupStatusBadge(status)
        case .booked:
            setupBookedBadge()
        }
    }
    
    // MARK: - Private Methods
    private func resetView() {
        self.text = nil
        self.textColor = .black
        self.image = nil
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        removeGradientLayer()
    }
    
    private func setupStatusBadge(_ status: ProductStatus) {
        var buttonTitle: String?
        var buttonTitleColor: UIColor?
        var chipBorderColor: UIColor?
        
        switch status {
        case .hot:
            buttonTitle = Constants.hotButtonTitle
            buttonTitleColor = UIColor.AppColors.redChipTitleColor
            chipBorderColor = UIColor.AppColors.redChipOutlineColor
            applyStatusGradient(for: status)
            
        case .developerRed:
            buttonTitle = Constants.developerLabel
            buttonTitleColor = UIColor.AppColors.redChipTitleColor
            chipBorderColor = UIColor.AppColors.redChipOutlineColor
            
        case .signature:
            buttonTitle = Constants.signatureButtonTitle
            buttonTitleColor = UIColor.AppColors.blueChipTitleColor
            chipBorderColor = UIColor.AppColors.blueChipOutlineColor
            applyStatusGradient(for: status)
            
        case .developerBlue:
            buttonTitle = Constants.developerLabel
            buttonTitleColor = UIColor.AppColors.blueChipTitleColor
            chipBorderColor = UIColor.AppColors.blueChipOutlineColor
            
        case .developerGray:
            buttonTitle = Constants.developerLabel
            buttonTitleColor = UIColor.AppColors.grayChipTitleColor
            chipBorderColor = UIColor.AppColors.grayChipOutlineColor
            
        case .developerInserted:
            buttonTitle = Constants.developerLabel
            buttonTitleColor = UIColor.AppColors.green5
            chipBorderColor = UIColor.AppColors.grayChipOutlineColor
            
        case .none:
            self.isHidden = true
            return
        }
        
        self.isHidden = false
        self.text = buttonTitle
        self.textColor = buttonTitleColor
        self.layer.borderColor = chipBorderColor?.cgColor
        self.layer.borderWidth = chipBorderColor != nil ? 1 : 0
        self.layer.cornerRadius = 12
    }
    
    private func setupBookedBadge() {
        self.isHidden = false
        self.text = Constants.bookedText
        self.textColor = .white
        self.image = UIImage(named: Constants.bookedIcon)
        self.layer.cornerRadius = 12
        
        let colors = [
            UIColor.AppColors.bookUntilGradientColor1.cgColor,
            UIColor.AppColors.bookUntilGradientColor2.cgColor
        ]
        self.setGradient(colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    }
    
    private func applyStatusGradient(for status: ProductStatus) {
        let colors: [CGColor]
        let imageName: String
        
        switch status {
        case .hot:
            imageName = Constants.hotIcon
            colors = [
                UIColor.AppColors.hotTagGradientColor1.cgColor,
                UIColor.AppColors.hotTagGradientColor2.cgColor
            ]
        case .signature:
            imageName = Constants.signatureIcon
            colors = [
                UIColor.AppColors.signatureTagGradientColor1.cgColor,
                UIColor.AppColors.signatureTagGradientColor2.cgColor
            ]
        default:
            return
        }
        
        self.setGradient(colors: colors)
        self.textColor = .white
        self.image = UIImage(named: imageName)
    }
}
