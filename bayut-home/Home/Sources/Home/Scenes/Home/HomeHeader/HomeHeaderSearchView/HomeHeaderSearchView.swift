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
    private var isPurposeHidden = false
    
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
        view.backgroundColor = .grey1
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
        btn.setTitle(HomePurpose.buy.title, for: .normal)
        btn.titleLabel?.font = .headingL4
        btn.backgroundColor = .green1
        btn.setTitleColor(.green5 ,for: .normal)
        btn.layer.cornerRadius = 4
        btn.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return btn
    }()
    
    private let rentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(HomePurpose.rent.title, for: .normal)
        btn.titleLabel?.font = .bodyL0
        btn.backgroundColor = .white
        btn.setTitleColor(.grey5, for: .normal)
        btn.layer.cornerRadius = 4
        btn.setBorder(.grey1, width: 1)
        btn.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return btn
    }()
    
    var onPurposeSelected: ((HomePurpose) -> Void)?
    private(set) var selectedPurpose: HomePurpose = .buy
    
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
        iv.image = UIImage(named: "HomeSearchIcon", in: .module, compatibleWith: nil)?.localized()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let searchLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "searchLocation".localized()
        lbl.textColor = .grey4
        lbl.font = .bodyL1
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
            toggleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            toggleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            toggleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            separatorView.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
        ])
        
        let searchTop = searchContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50)
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
            searchIcon.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),
            
            searchLabel.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchLabel.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -8),
            searchLabel.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
        ])
        
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        rentButton.addTarget(self, action: #selector(rentTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchContainerTapped))
        searchContainer.addGestureRecognizer(tap)
        searchContainer.isUserInteractionEnabled = true
    }
    
    var onSearchTapped: (() -> Void)?
    var onHeightChanged: (() -> Void)?
    
    @objc private func searchContainerTapped() {
        onSearchTapped?()
    }
    
    @objc private func buyTapped() {
        selectedPurpose = .buy
        updatePurposeSelection(isBuy: true)
        onPurposeSelected?(.buy)
    }
    
    @objc private func rentTapped() {
        selectedPurpose = .rent
        updatePurposeSelection(isBuy: false)
        onPurposeSelected?(.rent)
    }
    
    private func updatePurposeSelection(isBuy: Bool) {
        let (activeButton, inactiveButton) = isBuy ? (buyButton, rentButton) : (rentButton, buyButton)
        
        activeButton.backgroundColor = .green1
        activeButton.setTitleColor(.green5, for: .normal)
        activeButton.titleLabel?.font = .headingL4
        activeButton.layer.borderWidth = 0
        
        inactiveButton.backgroundColor = .white
        inactiveButton.setTitleColor(.grey5, for: .normal)
        inactiveButton.titleLabel?.font = .bodyL0
        inactiveButton.setBorder(.grey1, width: 1)
    }
    
    struct AnimationConfig {
        var initialContainerTop: CGFloat = 25
        var targetContainerTop: CGFloat = -40
        var internalSearchTop: CGFloat = 50
    }
    
    var animationConfig = AnimationConfig()
    
    // MARK: - Animation Support
    func setProgress(_ progress: CGFloat) {
        let fadeStart: CGFloat = 0.5
        let fadeAlpha: CGFloat = progress < fadeStart ? 1.0 : (1.0 - (progress - fadeStart) / (1.0 - fadeStart))
        
        containerView.backgroundColor = .white.withAlphaComponent(fadeAlpha)
        layer.shadowOpacity = 0.1 * Float(fadeAlpha)
        
        if isPurposeHidden {
            toggleStackView.alpha = 0
            toggleStackView.isHidden = true
            separatorView.alpha = 0
            separatorView.isHidden = true
        } else {
            toggleStackView.alpha = fadeAlpha
            toggleStackView.isHidden = progress == 1
            separatorView.alpha = fadeAlpha
            separatorView.isHidden = progress == 1
        }
        
        let initial = animationConfig.initialContainerTop
        var target = animationConfig.targetContainerTop
        
        if isPurposeHidden {
            target = target + (animationConfig.internalSearchTop)
        }
        
        containerTopConstraint?.constant = initial + (target - initial + 12) * progress
        searchTopConstraint?.constant = isPurposeHidden ? 0 : animationConfig.internalSearchTop
    }
    
    func setCollapsedState(_ isCollapsed: Bool) {
        setProgress(isCollapsed ? 1 : 0)
    }
    
    func showPurposeButtons(_ show: Bool) {
        isPurposeHidden = !show
        searchTopConstraint?.constant = show ? animationConfig.internalSearchTop : 0
        onHeightChanged?()
    }
    
    func preparePurposeAnimation() {
        if !isPurposeHidden {
            toggleStackView.isHidden = false
            separatorView.isHidden = false
        }
    }
    
    func applyPurposeAlpha() {
        let show = !isPurposeHidden
        toggleStackView.alpha = show ? 1.0 : 0.0
        separatorView.alpha = show ? 1.0 : 0.0
    }
    
    func configure(with viewModel: HomeHeaderSearchViewModel) {
        buyButton.setTitle(viewModel.firstButtonTitle, for: .normal)
        rentButton.setTitle(viewModel.secondButtonTitle, for: .normal)
        searchLabel.text = viewModel.searchPlaceholder
        isPurposeHidden = !viewModel.showButtonsView
        searchTopConstraint?.constant = viewModel.showButtonsView ? animationConfig.internalSearchTop : 0
        onHeightChanged?()
    }
    
    func finalizePurposeVisibility() {
        if isPurposeHidden {
            toggleStackView.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    var contentHeight: CGFloat {
        let containerTop = containerTopConstraint?.constant ?? animationConfig.initialContainerTop
        let searchTop = isPurposeHidden ? 0 : (searchTopConstraint?.constant ?? animationConfig.internalSearchTop)
        return containerTop + searchTop + 48
    }
}
