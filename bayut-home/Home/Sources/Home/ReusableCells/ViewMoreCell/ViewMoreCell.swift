//
//  ViewMoreCell.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 28/11/2025.
//

import UIKit
import UIToolKit

final class ViewMoreCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private lazy var button: PrimaryDarkButton = {
        let btn = PrimaryDarkButton()
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
        button.setupTealColors()
        button.applyButtonConfiguration(
            title: buttonTitle,
            iconName: Constants.chevronRight,
            font: .boldBody,
            titleColor: .teal5,
            iconColor: .teal5,
            imagePlacement: .trailing,
            imagePadding: Constants.iconPadding,
            cornerRadius: 8
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
