//
//  TruBrokerBadge.swift
//  Bayut
//
//  Created by Hammad Shahid on 16/04/2026.
//  Copyright © 2026 Zameen.com. All rights reserved.
//

import UIKit

final class TruBrokerBadgeView: UIView {
    //MARK: - Properties
    private var actionCallback: (() -> Void)?
    private var hasStories: Bool = false
    private var isAnimating: Bool = false
    //MARK: - IBOutlets
    @IBOutlet private var backgroundView: UIView?
    @IBOutlet private weak var displayImageView: UIImageView?
    @IBOutlet private weak var gradientView: UIView?
    @IBOutlet private weak var transparentButton: UIButton?
    @IBOutlet private weak var badgeWidthConstraint: NSLayoutConstraint?
    @IBOutlet private weak var avatar: UIImageView?
    @IBOutlet private weak var trubrokerLabel: UILabel?
    @IBOutlet private weak var displayPictureY: NSLayoutConstraint?
    @IBOutlet private weak var badgeLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var placeHolderViewForShadow: UIView?
    @IBOutlet private weak var shadowViewTrailingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var shadowViewLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var blurEffectView: UIVisualEffectView?
    @IBOutlet private weak var profilePictureLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var playIconImageView: UIImageView?
    @IBOutlet private weak var playIconLeadingConstraint: NSLayoutConstraint?
    
    private struct Constants {
        static let truBrokerBadgeIdentifier = "TRUBROKER_BADGE_VIEW_IDENTIFIER"
        static let playIconBadgeIdentifier = "PLAY_ICON_VIEW_IDENTIFIER"
        static let viewStoryBadgeIdentifier = "VIEW_STORY_BADGE_IDENTIFIER"
        static let truBrokerText = "TruBroker".localized()
        static let viewStoryText = "viewStory".localized()
        static let brokerText = "broker".localized()
    }
        
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar?.updateGradientLayerFrame()
        if !isAnimating{
            placeHolderViewForShadow?.updateShadowFrame()
        }
    }
    //MARK: - Actions
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "TruBrokerBadge") else {
            return
        }
        view.frame = self.bounds
        addSubview(view)
        
        accessibilityIdentifier = Constants.truBrokerBadgeIdentifier
        gradientView?.accessibilityIdentifier = nil
        playIconImageView?.accessibilityIdentifier = nil
        
        isAnimating = false
        transparentButton?.setTitle("", for: .normal)
        
        displayImageView?.setRoundedWithRespectToHeight(shouldClipToBounds: true)
        displayImageView?.backgroundColor = UIColor.grey1
        
        backgroundView?.addBadgeShadow(opacity: 0.2)
        backgroundView?.backgroundColor = UIColor.clear
        
        avatar?.setRoundedWithRespectToHeight(shouldClipToBounds: true)
        
        gradientView?.layer.cornerRadius = 11.0
        gradientView?.backgroundColor = UIColor.clear
        
        trubrokerLabel?.textColor = UIColor.white
        trubrokerLabel?.font = UIFont.bodyS1
        trubrokerLabel?.text = Constants.truBrokerText
        trubrokerLabel?.highlight(text: Constants.brokerText, font: UIFont.headingL6)
        avatar?.setRoundedWithRespectToHeight()
        avatar?.setGradient(
            colors: [
                UIColor.white.cgColor,
                UIColor.lightGreenChipColor.cgColor
            ],
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        
        placeHolderViewForShadow?.backgroundColor = UIColor.clear
        placeHolderViewForShadow?.applyShadow(offsetX: -4, offsetY: 0, blur: 16.7, spread: 0, color: UIColor.white, opacity: 0.5)
        blurEffectView?.setRoundedWithRespectToHeight()
        playIconImageView?.image = UIImage(named: "stories-play")
        playIconImageView?.backgroundColor = .white
        playIconImageView?.setRoundedWithRespectToHeight()
        playIconImageView?.isHidden = true
        if var gradientView = gradientView {
            layoutGradient(on: &gradientView)
        }
    }
    
    func set(imageUrl: URL?, hasStories: Bool = false, action: (() -> Void)?, currentThumbnailIndex: Int) {
        guard let imageUrl = imageUrl else { return }
        displayImageView?.loadImage(with: imageUrl)
        actionCallback = action
        self.hasStories = hasStories
        
        setBadgeUI()
        
        if currentThumbnailIndex == 0 {
            expand(duration: 0.0, delay: 0.0)
        } else {
            collapse(duration: 0.0, delay: 0.0)
        }
    }
    
    func collapse(duration: TimeInterval = 0.3, delay: TimeInterval = 0.15) {
        guard !isAnimating else {
            return
        }
        
        let completion: (() -> Void)? = { [weak self] in
            self?.isAnimating = false
        }
        
        collapseChip(duration: duration, delay: delay, completion: completion)
    }
    
    func expand(duration: TimeInterval = 0.3, delay: TimeInterval = 0.15) {
        guard !isAnimating else {
            return
        }
        
        let completion: (() -> Void)? = { [weak self] in
            self?.isAnimating = false
        }

        expandChip(duration: duration, delay: delay, completion: completion)
    }
    
    private func expandChip(duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)?){
        isAnimating = true
        badgeWidthConstraint?.constant = 24
        let expandedWidth: CGFloat = 98.0
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            self?.badgeWidthConstraint?.constant = expandedWidth
            self?.gradientView?.alpha = 1.0
            self?.badgeLeadingConstraint?.constant = 8.0
            self?.shadowViewTrailingConstraint?.constant = expandedWidth - 18.0
            self?.layoutIfNeeded()
            self?.placeHolderViewForShadow?.updateShadowFrame()
        }, completion: { [weak self] _ in
            completion?()
        })
    }
    
    private func collapseChip(duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)?){
        isAnimating = true
        let collapsedWidth: CGFloat = 0.0
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            self?.badgeWidthConstraint?.constant = collapsedWidth
            self?.gradientView?.alpha = 0.0
            self?.badgeLeadingConstraint?.constant = 0.0
            self?.shadowViewTrailingConstraint?.constant = collapsedWidth + 2.0
            self?.badgeLeadingConstraint?.constant = 0.0
            self?.layoutIfNeeded()
            self?.placeHolderViewForShadow?.updateShadowFrame()
        }, completion: { [weak self] _ in
            completion?()
        })
    }
    
    private func displayViewStory(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.profilePictureLeadingConstraint?.constant = 26
            self?.displayImageView?.alpha = 0
            self?.avatar?.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.trubrokerLabel?.text = Constants.viewStoryText
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.playIconImageView?.alpha = 1
                self?.playIconLeadingConstraint?.constant = 0
                self?.layoutIfNeeded()
            }, completion: { _ in
                completion?()
            })
        })
    }
    
    private func displayTruBrokerBadge(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.playIconLeadingConstraint?.constant = 26
            self?.playIconImageView?.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.trubrokerLabel?.text = Constants.truBrokerText
            self?.trubrokerLabel?.highlight(text: Constants.brokerText, font: UIFont.headingL6)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.profilePictureLeadingConstraint?.constant = 0
                self?.displayImageView?.alpha = 1
                self?.avatar?.alpha = 1
                self?.layoutIfNeeded()
            }, completion: { _ in
                completion?()
            })
        })
    }
    
    private func setBadgeUI() {
        displayImageView?.isHidden = hasStories
        avatar?.isHidden = hasStories
        playIconImageView?.isHidden = !hasStories
        trubrokerLabel?.text = hasStories ? Constants.viewStoryText : Constants.truBrokerText
        trubrokerLabel?.highlight(text: Constants.brokerText, font: UIFont.headingL6)
        gradientView?.accessibilityIdentifier = hasStories ? Constants.viewStoryBadgeIdentifier : nil
        playIconImageView?.accessibilityIdentifier = hasStories ? Constants.playIconBadgeIdentifier : nil
    }
    
    //MARK: - IBActions
    @IBAction private func badgeAction(_ sender: UIButton) {
        actionCallback?()
    }
    
    private func layoutGradient(on component: inout UIView){
        component.applyTruBrokerTheme()
    }
}
