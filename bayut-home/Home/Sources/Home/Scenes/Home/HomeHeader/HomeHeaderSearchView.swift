//
//  HomeHeaderSearchView.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

class HomeHeaderSearchView: UIView {
    
    private var searchTopConstraint: NSLayoutConstraint?
    private var containerTopConstraint: NSLayoutConstraint?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    // Separator
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        return view
    }()
    
    // Buy/Rent Toggle
    private let toggleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private let buyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Buy", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.backgroundColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 0.1)
        btn.setTitleColor(UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0), for: .normal)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return btn
    }()
    
    private let rentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Rent", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.backgroundColor = .systemGray6
        btn.setTitleColor(.darkGray, for: .normal)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return btn
    }()
    
    var onPurposeSelected: ((String) -> Void)?
    
    // Search Bar
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Search-Icon", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0)
        return iv
    }()
    
    private let searchLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Search for a locality, area or city"
        lbl.textColor = .lightGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        
        addSubview(containerView)
        containerView.addSubview(toggleStackView)
        containerView.addSubview(separatorView)
        containerView.addSubview(searchContainer)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        toggleStackView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let containerTop = containerView.topAnchor.constraint(equalTo: topAnchor)
        self.containerTopConstraint = containerTop
        containerTop.isActive = true
        
        NSLayoutConstraint.activate([
            toggleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            toggleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            toggleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            separatorView.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
        ])
        
        let searchTop = searchContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 70)
        self.searchTopConstraint = searchTop
        
        NSLayoutConstraint.activate([
            searchTop,
            searchContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        toggleStackView.addArrangedSubview(buyButton)
        toggleStackView.addArrangedSubview(rentButton)
        
        // Add Search Container
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchLabel)
        
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchIcon.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            searchLabel.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchLabel.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -8),
            searchLabel.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
        ])
        
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        rentButton.addTarget(self, action: #selector(rentTapped), for: .touchUpInside)
    }
    
    @objc private func buyTapped() {
        updatePurposeSelection(isBuy: true)
        onPurposeSelected?("buy")
    }
    
    @objc private func rentTapped() {
        updatePurposeSelection(isBuy: false)
        onPurposeSelected?("rent")
    }
    
    private func updatePurposeSelection(isBuy: Bool) {
        let activeColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0)
        let inactiveColor = UIColor.systemGray6
        
        buyButton.backgroundColor = isBuy ? activeColor.withAlphaComponent(0.1) : inactiveColor
        buyButton.setTitleColor(isBuy ? activeColor : .darkGray, for: .normal)
        
        rentButton.backgroundColor = !isBuy ? activeColor.withAlphaComponent(0.1) : inactiveColor
        rentButton.setTitleColor(!isBuy ? activeColor : .darkGray, for: .normal)
    }
    
    struct AnimationConfig {
        var initialContainerTop: CGFloat = 25
        var targetContainerTop: CGFloat = -40
        var internalSearchTop: CGFloat = 55
    }
    
    var animationConfig = AnimationConfig()
    
    // MARK: - Animation Support
    func setProgress(_ progress: CGFloat) {
        let activeColor = UIColor(red: 0, green: 173/255, blue: 101/255, alpha: 1.0)
        
        let fadeStart: CGFloat = 0.5
        let fadeAlpha: CGFloat = progress < fadeStart ? 1.0 : (1.0 - (progress - fadeStart) / (1.0 - fadeStart))
        
        containerView.backgroundColor = .white.withAlphaComponent(fadeAlpha)
        layer.shadowOpacity = 0.1 * Float(fadeAlpha)
        
        toggleStackView.alpha = fadeAlpha
        toggleStackView.isHidden = progress == 1
        
        separatorView.alpha = fadeAlpha
        separatorView.isHidden = progress == 1
        
        // Container top animation (The whole box moves as one) using generic offset
        let initial = animationConfig.initialContainerTop
        let target = animationConfig.targetContainerTop
        containerTopConstraint?.constant = initial + (target - initial) * progress
        
        searchTopConstraint?.constant = animationConfig.internalSearchTop
    }
    
    func setCollapsedState(_ isCollapsed: Bool) {
        setProgress(isCollapsed ? 1 : 0)
    }
}
