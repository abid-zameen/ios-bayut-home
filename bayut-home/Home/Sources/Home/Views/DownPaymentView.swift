//
//  DownPaymentView.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//

import UIKit

class DownPaymentView: UIView {
    
    // MARK: - UI Components
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lilac1
        view.layer.cornerRadius = 6.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_downpayment")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let downPaymentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appRegularFont(ofSize: 12.0)
        label.textColor = UIColor.lilac5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(mainView)
        mainView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(downPaymentLabel)
        
        NSLayoutConstraint.activate([
            // Main View constraints (pinned to left in legacy, but usually occupies content in cell)
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            // Stack View constraints inside Main View with 8pt padding
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 4),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -4),
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            
            // Icon Constraints
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        // Handle RTL alignment for stack view if needed
        mainStackView.semanticContentAttribute = .unspecified
    }
    
    // MARK: - Functions
    func configureView(downPayment: String?) {
        if let downPayment = downPayment, !downPayment.isEmpty {
            let prefix = "downPaymentUpdated".localized()
            downPaymentLabel.text = prefix + ": " + downPayment
            downPaymentLabel.highlight(text: prefix, font: UIFont.headingL6)
        }
    }
}
