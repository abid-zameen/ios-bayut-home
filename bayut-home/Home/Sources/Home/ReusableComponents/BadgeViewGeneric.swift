//
//  BadgeViewGeneric.swift
//  Home
//
//  Created by Hammad Shahid on 08/04/2026.
//

import UIKit

class BadgeViewGeneric: ShadowRoundedView {
    // MARK: - Views
    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Public API
    public var text: String? {
        get { title.text }
        set { title.text = newValue }
    }

    public var textColor: UIColor? {
        get { title.textColor }
        set { title.textColor = newValue }
    }
    
     var image: UIImage? {
        get { icon.image }
        set {
            icon.image = newValue
            icon.isHidden = newValue == nil
        }
    }
    
    // MARK: - View cycle
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func setupInactive() {
       // self.title.setInactiveText()
    }
    
    private func commonInit() {
        setupViews()
    }
}

// MARK: - View setup
private extension BadgeViewGeneric {
    func setupViews() {
        clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [icon, title])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            icon.widthAnchor.constraint(equalToConstant: 13),
            icon.heightAnchor.constraint(equalToConstant: 13)
        ])
        //if !Environment.isProductTagGradientEnabled {
            self.layer.borderWidth = 1
        //}
    }
}

