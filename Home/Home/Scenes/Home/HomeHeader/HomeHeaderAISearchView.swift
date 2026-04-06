//
//  HomeHeaderAISearchView.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

final class HomeHeaderAISearchView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 26
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return view
    }()
    
    private let aiIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai_search_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let aiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Search your dream home with AI"
        lbl.textColor = .darkGray
        lbl.font = .bodyL1
        return lbl
    }()
    
    private let aiBadge: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI"
        lbl.textColor = .AppColors.blackTextColor
        lbl.font = .boldBody
        return lbl
    }()
    
    // MARK: - Constants
    private enum Constants {
        static let gradientLayerName = "animatedGradientBorder"
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reApplyAnimatedGradient()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        applyGradientBorder()
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(aiIcon)
        containerView.addSubview(aiLabel)
        containerView.addSubview(aiBadge)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        aiIcon.translatesAutoresizingMaskIntoConstraints = false
        aiLabel.translatesAutoresizingMaskIntoConstraints = false
        aiBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            aiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            aiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            aiBadge.leadingAnchor.constraint(greaterThanOrEqualTo: aiLabel.trailingAnchor, constant: 8),
            aiBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            aiBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            aiIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            aiIcon.trailingAnchor.constraint(equalTo: aiBadge.leadingAnchor),
            aiIcon.widthAnchor.constraint(equalToConstant: 24),
            aiIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Animation Support
    func setProgress(_ progress: CGFloat) {
        containerView.backgroundColor = .white
        
        // Text and Badge colors
        aiLabel.textColor = progress > 0.5 ? .black : .darkGray
    }
    
    func reApplyAnimatedGradient() {
        if let gradient = layer.sublayers?.first(where: { $0.name == Constants.gradientLayerName }) as? CAGradientLayer {
            gradient.frame = bounds
            if let shape = gradient.mask as? CAShapeLayer {
                shape.path = UIBezierPath(
                    roundedRect: bounds.insetBy(dx: 1, dy: 1),
                    cornerRadius: 24
                ).cgPath
            }
        }
    }
    
    func applyGradientBorder() {
        applyAnimatedGradientBorder(colors: [
            UIColor.AppColors.blue5,
            UIColor.AppColors.green2,
            UIColor.AppColors.lightDividerColorSecondary,
            UIColor.AppColors.lightDividerColorSecondary,
            UIColor.AppColors.green5
        ], lineWidth: 2, cornerRadius: 24)
    }
}
