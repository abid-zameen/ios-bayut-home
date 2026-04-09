//
//  TruBrokerBadge.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//

import UIKit
import Kingfisher

final class TruBrokerBadge: UIView {
    
    // MARK: - Properties
    private var actionCallback: (() -> Void)?
    private var hasStories: Bool = false
    private var isAnimating: Bool = false
    private var badgeWidthConstraint: NSLayoutConstraint!
    private var badgeLeadingConstraint: NSLayoutConstraint!
    private var shadowViewTrailingConstraint: NSLayoutConstraint!
    private var profilePictureLeadingConstraint: NSLayoutConstraint!
    private var playIconLeadingConstraint: NSLayoutConstraint!
    
    private struct Constants {
        static let truBrokerBadgeIdentifier = "TRUBROKER_BADGE_VIEW_IDENTIFIER"
        static let playIconBadgeIdentifier = "PLAY_ICON_VIEW_IDENTIFIER"
        static let viewStoryBadgeIdentifier = "VIEW_STORY_BADGE_IDENTIFIER"
        static let truBrokerText = "truBroker".localized()
        static let viewStoryText = "viewStory".localized()
        static let brokerText = "broker".localized()
        static let expandedWidth: CGFloat = 98.0
        static let collapsedWidth: CGFloat = 0.0
    }
    
    // MARK: - UI Components
    private let backgroundContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeHolderViewForShadow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: blur)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 11.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trubrokerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.bodyS1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let baseAvatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.AppColors.grey1 // greyBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let playIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stories-play")
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let transparentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force gradient updates
        gradientView.applyTruBrokerTheme()
        avatar.setRoundedWithRespectToHeight()
        displayImageView.setRoundedWithRespectToHeight(shouldClipToBounds: true)
        blurEffectView.setRoundedWithRespectToHeight()
        playIconImageView.setRoundedWithRespectToHeight()
        
        avatar.setGradient(
            colors: [
                UIColor.white.cgColor,
                UIColor.AppColors.lightGreenChipColor.cgColor
            ],
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        
        if !isAnimating {
            placeHolderViewForShadow.updateShadowFrame()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        accessibilityIdentifier = Constants.truBrokerBadgeIdentifier
        
        addSubview(backgroundContainer)
        backgroundContainer.addSubview(placeHolderViewForShadow)
        backgroundContainer.addSubview(blurEffectView)
        backgroundContainer.addSubview(gradientView)
        gradientView.addSubview(trubrokerLabel)
        
        backgroundContainer.addSubview(baseAvatarView)
        backgroundContainer.addSubview(avatar)
        backgroundContainer.addSubview(displayImageView)
        backgroundContainer.addSubview(playIconImageView)
        backgroundContainer.addSubview(transparentButton)
        
        setupConstraints()
        
        backgroundContainer.addBadgeShadow(opacity: 0.2)
        placeHolderViewForShadow.applyShadow(offsetX: -4, offsetY: 0, blur: 16.7, spread: 0, color: .white, opacity: 0.5)
        
        transparentButton.addTarget(self, action: #selector(badgeAction), for: .touchUpInside)
        
        trubrokerLabel.text = Constants.truBrokerText
        trubrokerLabel.highlight(text: Constants.brokerText, font: UIFont.headingL6)
    }
    
    private func setupConstraints() {
        badgeWidthConstraint = gradientView.widthAnchor.constraint(equalToConstant: Constants.expandedWidth)
        badgeLeadingConstraint = gradientView.leadingAnchor.constraint(equalTo: baseAvatarView.leadingAnchor, constant: 8.0)
        shadowViewTrailingConstraint = placeHolderViewForShadow.trailingAnchor.constraint(equalTo: baseAvatarView.trailingAnchor, constant: 70.0)
        profilePictureLeadingConstraint = displayImageView.centerXAnchor.constraint(equalTo: avatar.centerXAnchor)
        playIconLeadingConstraint = playIconImageView.leadingAnchor.constraint(equalTo: baseAvatarView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            backgroundContainer.topAnchor.constraint(equalTo: topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            baseAvatarView.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 8.0),
            baseAvatarView.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor),
            baseAvatarView.widthAnchor.constraint(equalToConstant: 28),
            baseAvatarView.heightAnchor.constraint(equalToConstant: 28),
            
            avatar.centerXAnchor.constraint(equalTo: baseAvatarView.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: baseAvatarView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 28),
            avatar.heightAnchor.constraint(equalToConstant: 28),
            
            displayImageView.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            displayImageView.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            displayImageView.widthAnchor.constraint(equalToConstant: 24),
            displayImageView.heightAnchor.constraint(equalToConstant: 24),
            
            playIconImageView.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            playIconImageView.widthAnchor.constraint(equalToConstant: 28),
            playIconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            gradientView.centerYAnchor.constraint(equalTo: displayImageView.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 24),
            badgeLeadingConstraint,
            badgeWidthConstraint,
            
            trubrokerLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 24),
            trubrokerLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            trubrokerLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientView.trailingAnchor, constant: -8),
            
            blurEffectView.topAnchor.constraint(equalTo: placeHolderViewForShadow.topAnchor, constant: -0.5),
            blurEffectView.leadingAnchor.constraint(equalTo: placeHolderViewForShadow.leadingAnchor, constant: -0.5),
            blurEffectView.trailingAnchor.constraint(equalTo: placeHolderViewForShadow.trailingAnchor, constant: -8),
            blurEffectView.bottomAnchor.constraint(equalTo: placeHolderViewForShadow.bottomAnchor, constant: 0.5),
            
            placeHolderViewForShadow.topAnchor.constraint(equalTo: avatar.topAnchor),
            placeHolderViewForShadow.leadingAnchor.constraint(equalTo: baseAvatarView.leadingAnchor),
            placeHolderViewForShadow.bottomAnchor.constraint(equalTo: avatar.bottomAnchor),
            shadowViewTrailingConstraint,
            
            transparentButton.topAnchor.constraint(equalTo: backgroundContainer.topAnchor),
            transparentButton.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor),
            transparentButton.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor),
            transparentButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: 28)
        ])
    }
    
    // MARK: - Public API
    func set(imageUrl: URL?, hasStories: Bool = false, action: (() -> Void)?, currentThumbnailIndex: Int) {
        if let imageUrl = imageUrl {
            displayImageView.kf.setImage(with: imageUrl)
        }
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
        guard !isAnimating else { return }
        isAnimating = true
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            self?.badgeWidthConstraint.constant = Constants.collapsedWidth
            self?.gradientView.alpha = 0.0
            self?.badgeLeadingConstraint.constant = 0.0
            self?.shadowViewTrailingConstraint.constant = 2.0
            self?.layoutIfNeeded()
            self?.placeHolderViewForShadow.updateShadowFrame()
        }, completion: { [weak self] _ in
            self?.isAnimating = false
        })
    }
    
    func expand(duration: TimeInterval = 0.3, delay: TimeInterval = 0.15) {
        guard !isAnimating else { return }
        isAnimating = true
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            self?.badgeWidthConstraint.constant = Constants.expandedWidth
            self?.gradientView.alpha = 1.0
            self?.badgeLeadingConstraint.constant = 8.0
            self?.shadowViewTrailingConstraint.constant = Constants.expandedWidth - 18.0
            self?.layoutIfNeeded()
            self?.placeHolderViewForShadow.updateShadowFrame()
        }, completion: { [weak self] _ in
            self?.isAnimating = false
        })
    }
    
    // MARK: - Private Logic
    private func setBadgeUI() {
        displayImageView.isHidden = hasStories
        avatar.isHidden = hasStories
        playIconImageView.isHidden = !hasStories
        trubrokerLabel.text = hasStories ? Constants.viewStoryText : Constants.truBrokerText
        trubrokerLabel.highlight(text: Constants.brokerText, font: UIFont.headingL6)
        gradientView.accessibilityIdentifier = hasStories ? Constants.viewStoryBadgeIdentifier : nil
        playIconImageView.accessibilityIdentifier = hasStories ? Constants.playIconBadgeIdentifier : nil
    }
    
    @objc private func badgeAction() {
        actionCallback?()
    }
}
