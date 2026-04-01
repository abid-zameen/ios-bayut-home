//
//  ViewMoreCell.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 28/11/2025.
//

import UIKit

final class ViewMoreCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private lazy var button: UIButton = {
        let btn = PrimaryOutlinedButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Properties
    private var viewMoreAction: (() -> Void)?
    
    private enum Constants {
        static let buttonHeight: CGFloat = 40
        static let iconPadding: CGFloat = 8
        static let bottomConstraintPriority: Float = 999
        static let chevronRight = "chevron_right"
        static let topPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Configuration
    func configure(buttonTitle: String, action: (() -> Void)?) {
        viewMoreAction = action
        
        button.applyButtonConfiguration(
            title: buttonTitle,
            iconName: Constants.chevronRight,
            font: .boldBody,
            titleColor: .AppColors.teal5,
            iconColor: .AppColors.teal5,
            imagePlacement: .trailing,
            imagePadding: Constants.iconPadding
        )
    }
    
    // MARK: - Actions
    @objc private func didTap() {
        viewMoreAction?()
    }
}

// MARK: - Setup
private extension ViewMoreCell {
    func setupViews() {
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPadding),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                .withPriority(Constants.bottomConstraintPriority),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}
