//
//  TitleCell.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 27/11/2025.
//

import UIKit

// MARK: - Title Cell
final class TitleCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headingL1
        label.numberOfLines = .zero
        label.textColor = .AppColors.grey7
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .AppColors.grey7
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Constants
    private enum Constants {
        static let topMargin: CGFloat = 16
        static let bottomConstraintPriority: Float = 999
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Configuration
    func configure(title: String, subtitle: String? = nil) {
        titleLabel.text = title
        
        if let subtitle {
            subTitleLabel.text = subtitle
            subTitleLabel.isHidden = false
        } else {
            subTitleLabel.isHidden = true
        }
    }
}

// MARK: - Setup
private extension TitleCell {
    func setupViews() {
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).withPriority(Constants.bottomConstraintPriority),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
