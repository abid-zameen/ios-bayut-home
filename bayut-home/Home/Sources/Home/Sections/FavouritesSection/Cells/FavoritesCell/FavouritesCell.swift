//
//  FavouritesCell.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit
import UIToolKit

final class FavouritesCell: HighlightableCollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var bgView: UIView?
    @IBOutlet private weak var propertyImageBgView: UIView?
    @IBOutlet private weak var propertyImageView: UIImageView?
    @IBOutlet private weak var trueCheckButton: UIButton?
    @IBOutlet private weak var favoriteButton: UIButton?
    @IBOutlet private weak var currencyPriceAndFrequencyLabel: UILabel?
    @IBOutlet private weak var bedsImageView: UIImageView?
    @IBOutlet private weak var bathsImageView: UIImageView?
    @IBOutlet private weak var areaImageView: UIImageView?
    @IBOutlet private weak var bedsLabel: UILabel?
    @IBOutlet private weak var bathsLabel: UILabel?
    @IBOutlet private weak var areaLabel: UILabel?
    @IBOutlet private weak var propertyTitleLabel: UILabel?
    @IBOutlet private weak var propertyAddressLabel: UILabel?
    @IBOutlet private weak var hotView: PropertyBadgeView?
    @IBOutlet private weak var bedStackView: UIStackView?
    @IBOutlet private weak var bathStackView: UIStackView?
    @IBOutlet private weak var areaStackView: UIStackView?
    @IBOutlet private weak var contactedView: UIView?
    @IBOutlet private weak var contactedLabel: UILabel?
    @IBOutlet private weak var viewedButtonTransparent: UIButton?
    @IBOutlet private weak var contactedViewWidth: NSLayoutConstraint?
    @IBOutlet private weak var contactedViewHeight: NSLayoutConstraint?
    @IBOutlet private weak var offPlanResaleBadgeView: UIView?
    @IBOutlet private weak var bookUntilDailyRentalTagView: PropertyBadgeView?
    @IBOutlet private weak var downPaymentInfoView: UIView?
    @IBOutlet private weak var downPaymentDetailView: DownPaymentView?
    @IBOutlet private weak var offPlanResaleLabel: UILabel?
    @IBOutlet private weak var resaleLabelStackView: UIStackView?
    @IBOutlet private weak var resaleLabel: UILabel?
    @IBOutlet private weak var potwView: UIView?
    @IBOutlet private weak var potwLabel: UILabel?
    @IBOutlet private weak var potwButton: UIButton?
    @IBOutlet private weak var truBrokerBadge: TruBrokerBadgeView?
    @IBOutlet private weak var offPlanInformationView: UIView?
    @IBOutlet private weak var offPlanDetailView: OffPlanPropertyCardView?
    @IBOutlet private weak var offplanResaleTransparentButton: UIButton?

    // MARK: - Properties
    private var viewModel: FavoritesCellViewModelType?
    var onFavoriteToggle: (() -> Void)?
    var onAction: ((FavouriteCellAction) -> Void)?
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? FavoritesCellViewModelType else { return }
        self.viewModel = viewModel
        setupWithViewModel()
    }
    
    // MARK: - IBActions
    @IBAction private func offplanResalePressedAction(_ sender: UIButton) {
        onAction?(.offplanResale)
    }
    
    @IBAction private func offplanPressedAction(_ sender: UIButton) {
        onAction?(.offplan)
    }
    
    @IBAction private func favoriteAction() {
        onFavoriteToggle?()
    }
    
    @IBAction private func viewedAction(_ sender: UIButton) {
        onAction?(.viewed)
    }
    
    @IBAction private func verificationAction() {
        onAction?(.verification)
    }
    
    @IBAction private func potwAction(_ sender: UIButton) {
        onAction?(.potw)
    }

}

// MARK: - Private Methods
private extension FavouritesCell {
    
    func setupViews() {
        let cardCornerRadius: CGFloat = 8
        
        hotView?.isHidden = !HomeModule.shared.environment.isProductTypeEnabled
        
        bgView?.setRoundedCorner(radius: cardCornerRadius)
        bgView?.setBorder(.clear, width: 1)
        
        propertyImageBgView?.backgroundColor = .white
        propertyImageBgView?.setRoundedCorner(radius: cardCornerRadius)
        propertyImageView?.setRoundedCorner(radius: cardCornerRadius)
        
        
        offPlanResaleBadgeView?.backgroundColor = UIColor.blue1
        offPlanResaleBadgeView?.layer.cornerRadius = 12
        offPlanResaleBadgeView?.addBadgeShadow()
        
        potwView?.layer.cornerRadius = 12.0
        potwView?.addBadgeShadow()
        potwView?.layer.borderWidth = 1.0
        potwView?.layer.borderColor = UIColor.purpleOutlineColor.cgColor
        potwView?.isHidden = !HomeModule.shared.environment.shouldShowDOTWChip
        potwLabel?.text = "potw".localized()
        potwLabel?.font = UIFont.headingL6
        potwLabel?.textColor = UIColor.purpleTitleColor
        
        offPlanResaleLabel?.text = "offplan".localized()
        resaleLabel?.text = "resale".localized()
        resaleLabel?.font = UIFont.appRegularFont(ofSize: 12.0)
        
        bedsLabel?.textColor = UIColor.grey7
        bedsLabel?.font = UIFont.body
        bathsLabel?.textColor = UIColor.grey7
        bathsLabel?.font = UIFont.body
        areaLabel?.textColor = UIColor.grey7
        areaLabel?.font = UIFont.body
        propertyTitleLabel?.textColor = UIColor.grey7
        propertyTitleLabel?.font = UIFont.semiBoldBody
        propertyAddressLabel?.textColor = UIColor.grey7
        propertyAddressLabel?.font = UIFont.body
        
        // 5. Icons Tinting
        let iconTint = UIColor.grey6
        bedsImageView?.tintColor = iconTint
        bathsImageView?.tintColor = iconTint
        areaImageView?.tintColor = iconTint
        
        // 6. Interaction Elements
        offplanResaleTransparentButton?.setTitle("", for: .normal)
        potwButton?.setTitle("", for: .normal)
        
        
        downPaymentInfoView?.isHidden = true
        
        setupViewedButtonAttributes()
        setupForViewedListing()
        bookUntilDailyRentalTagView?.isHidden = true
    }
    
    func setupWithViewModel() {
        guard let viewModel else { return }
        
        currencyPriceAndFrequencyLabel?.attributedText = viewModel.price
        propertyTitleLabel?.text = viewModel.title
        propertyAddressLabel?.text = viewModel.location
        
        bedsLabel?.text = viewModel.beds
        bathsLabel?.text = viewModel.baths
        areaLabel?.text = viewModel.area
        
        propertyImageView?.loadImage(with: viewModel.imageUrl)
        
        let truCheckButtomImage = UIImage(named: viewModel.isPropertyTruChecked ? "truCheckShadow" : "checkedGrey", in: .module, compatibleWith: nil)
        trueCheckButton?.setImage(truCheckButtomImage, for: .normal)
        
        setupForViewedListing()
        setBadgeComponent()
        
        if viewModel.showOffPlanInfo {
            offPlanResaleBadgeView?.isHidden = false
            offPlanDetailView?.property = viewModel.property
            offPlanDetailView?.paymentPlanInfoClick = { [weak self] _ in
                self?.onAction?(.paymentPlan)
            }
            resaleLabel?.text = viewModel.resaleLabelText
            resaleLabelStackView?.isHidden = !viewModel.showResaleInfo
            let hasOffPlanInfo = viewModel.property.handoverDate != nil || viewModel.property.paymentPlanPercentage != nil
            offPlanInformationView?.isHidden = !hasOffPlanInfo
        } else {
            offPlanResaleBadgeView?.isHidden = true
            offPlanInformationView?.isHidden = true
            resaleLabelStackView?.isHidden = true
        }
        
    }
    
    func setupViewedButtonAttributes() {
        contactedView?.backgroundColor = UIColor.grey1
        contactedView?.setRoundedWithRespectToHeight(shouldClipToBounds: true)
        contactedLabel?.textColor = UIColor.grey6
        contactedLabel?.font = UIFont.headingL6
        viewedButtonTransparent?.setBackgroundColor(color: .clear, forState: .normal)
        viewedButtonTransparent?.setTitle("" ,for: .normal)
    }
    
    func setupForViewedListing() {
        // TODO: Add ViewedListing support to the viewModel/Property
        contactedView?.isHidden = true
        contactedViewWidth?.constant = 0
        contactedView?.setRoundedWithRespectToHeight(shouldClipToBounds: true)
    }
    
    func setBadgeComponent() {
        guard let ownerAgent = viewModel?.property.ownerAgent,
              ownerAgent.isTruBroker == true else {
            truBrokerBadge?.isHidden = true
            return
        }
        
        truBrokerBadge?.isHidden = false
        let agentImageUrl = URL(string: ownerAgent.userImage ?? "")
        truBrokerBadge?.set(imageUrl: agentImageUrl, 
                           hasStories: false, 
                           action: { [weak self] in
                               self?.onAction?(.truBroker(url: agentImageUrl))
                           },
                           currentThumbnailIndex: 0)
    }
}
