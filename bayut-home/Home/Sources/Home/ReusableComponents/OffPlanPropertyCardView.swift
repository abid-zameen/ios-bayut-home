//
//  OffPlanPropertyCardView.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//

import UIKit

final class OffPlanPropertyCardView: UIView {
    
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let handoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.AppColors.grey1
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let handoverLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyS1
        label.textColor = UIColor.AppColors.blackTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paymentPlanView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.AppColors.grey1
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let paymentPlanStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let paymentPlanLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyS1
        label.textColor = UIColor.AppColors.blackTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paymentPlanInfoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "truCheckInfo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    var paymentPlanInfoClick: ((Property) -> Void)?
    
    var property: Property? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(handoverView)
        mainStackView.addArrangedSubview(paymentPlanView)
        
        handoverView.addSubview(handoverLabel)
        
        paymentPlanView.addSubview(paymentPlanStackView)
        paymentPlanStackView.addArrangedSubview(paymentPlanLabel)
        paymentPlanStackView.addArrangedSubview(paymentPlanInfoIcon)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            handoverLabel.topAnchor.constraint(equalTo: handoverView.topAnchor),
            handoverLabel.leadingAnchor.constraint(equalTo: handoverView.leadingAnchor, constant: 8),
            handoverLabel.trailingAnchor.constraint(equalTo: handoverView.trailingAnchor, constant: -8),
            handoverLabel.bottomAnchor.constraint(equalTo: handoverView.bottomAnchor),
            
            paymentPlanStackView.topAnchor.constraint(equalTo: paymentPlanView.topAnchor),
            paymentPlanStackView.leadingAnchor.constraint(equalTo: paymentPlanView.leadingAnchor, constant: 8),
            paymentPlanStackView.trailingAnchor.constraint(equalTo: paymentPlanView.trailingAnchor, constant: -8),
            paymentPlanStackView.bottomAnchor.constraint(equalTo: paymentPlanView.bottomAnchor),
            
            paymentPlanInfoIcon.widthAnchor.constraint(equalToConstant: 16),
            paymentPlanInfoIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let paymentPlanAction = UITapGestureRecognizer(target: self, action: #selector(paymentPlanBottomSheetAction))
        paymentPlanView.addGestureRecognizer(paymentPlanAction)
    }
    
    // MARK: - Configuration
    private func configureView() {
        guard let property = property else { return }
        
        handoverLabel.attributedText = property.handoverDate
        handoverView.isHidden = property.handoverDate?.string.isEmpty ?? true
        
        paymentPlanLabel.attributedText = property.paymentPlanPercentage
        paymentPlanView.isHidden = property.paymentPlanPercentage?.string.isEmpty ?? true
    }
    
    @objc private func paymentPlanBottomSheetAction() {
        if let property = property {
            paymentPlanInfoClick?(property)
        }
    }
}
