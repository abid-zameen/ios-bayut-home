//
//  HomeHeaderView.swift
//  Home
//
//  Created by Hammad Shahid on 03/04/2026.
//

import UIKit

class HomeHeaderView: UIView {
    
    // MARK: - UI Components
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Buildings", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let topCurveImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Header-Top-Curve", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let bottomCurveImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Header-Bottom-Curve", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bayut_logo", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()
    
    private let tabsView = HomeHeaderTabsView()
    private let aiSearchView = HomeHeaderAISearchView()
    private let searchView = HomeHeaderSearchView()
    
    private let dividerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "or continue using the filter below"
        lbl.textColor = .lightGray
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: - Layout Constraints (kept for setup & engine registration)
    private var logoHeightConstraint: NSLayoutConstraint?
    private var logoTopConstraint: NSLayoutConstraint?
    private var contentTopConstraint: NSLayoutConstraint?
    private var aiSearchTopConstraint: NSLayoutConstraint?
    private var searchTopConstraint: NSLayoutConstraint?
    private var dividerTopConstraint: NSLayoutConstraint?
    private var backgroundHeightConstraint: NSLayoutConstraint?
    private var backgroundTopConstraint: NSLayoutConstraint?
    private var bottomCurveHeightConstraint: NSLayoutConstraint?
    private var bottomCurveTopConstraint: NSLayoutConstraint?
    
    // MARK: - Animation Engine
    private let animationEngine = HeaderAnimationEngine()
    
    var variant: HeaderVariant = .uae {
        didSet {
            setupLayout()
        }
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
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = true
        
        addSubview(backgroundImageView)
        addSubview(topCurveImageView)
        addSubview(bottomCurveImageView)
        addSubview(logoImageView)
        addSubview(contentStackView)
        addSubview(aiSearchView)
        addSubview(dividerLabel)
        addSubview(searchView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topCurveImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomCurveImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        aiSearchView.translatesAutoresizingMaskIntoConstraints = false
        dividerLabel.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        logoHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: HomeHeaderLayout.ViewHeight.logo)
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 90)
        bottomCurveTopConstraint = bottomCurveImageView.topAnchor.constraint(equalTo: topAnchor, constant: 178)
        backgroundHeightConstraint = backgroundImageView.heightAnchor.constraint(equalToConstant: HomeHeaderLayout.ViewHeight.buildings)
        backgroundTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 64)
        
        NSLayoutConstraint.activate([
            backgroundTopConstraint!,
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundHeightConstraint!,
            
            topCurveImageView.topAnchor.constraint(equalTo: topAnchor, constant: 101),
            topCurveImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCurveImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCurveImageView.heightAnchor.constraint(equalToConstant: 125),
            
            bottomCurveImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCurveImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 154),
            logoHeightConstraint!,
            logoTopConstraint!,
            bottomCurveTopConstraint!
        ])
        
        bottomCurveHeightConstraint = bottomCurveImageView.heightAnchor.constraint(equalToConstant: 97)
        bottomCurveHeightConstraint?.isActive = true
        
        contentTopConstraint = contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 165)
        aiSearchTopConstraint = aiSearchView.topAnchor.constraint(equalTo: topAnchor, constant: 221)
        dividerTopConstraint = dividerLabel.topAnchor.constraint(equalTo: aiSearchView.bottomAnchor, constant: 8)
        searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: -17)
        
        let bottomPin = searchView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        bottomPin.priority = .defaultLow
        bottomPin.isActive = true
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            aiSearchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            aiSearchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dividerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        contentTopConstraint?.isActive = true
        
        setupLayout()
    }
    
    var visibleContentBottom: CGFloat {
        layoutIfNeeded()
        let subviewBottoms = subviews.map { $0.frame.maxY }
        return (subviewBottoms.max() ?? frame.height)
    }

    
    private func setupLayout() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStackView.spacing = 16
        contentStackView.addArrangedSubview(tabsView)
        
        updateConstraintsForVariant()
        setupElements()
    }
    
    private func updateConstraintsForVariant() {
        let isGCC = variant == .gcc
        
        aiSearchTopConstraint?.isActive = !isGCC
        dividerTopConstraint?.isActive = !isGCC
        
        aiSearchView.isHidden = isGCC
        dividerLabel.isHidden = isGCC
        
        if isGCC {
            searchTopConstraint?.isActive = false
            let l = HomeHeaderLayout.make(in: self)
            searchTopConstraint = searchView.topAnchor.constraint(equalTo: topAnchor, constant: l.gccSearchExpandedTop)
            searchTopConstraint?.isActive = true
        } else {
            searchTopConstraint?.isActive = false
            searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: -21)
            searchTopConstraint?.isActive = true
            aiSearchTopConstraint?.isActive = true
        }
    }
    
    private func setupElements() {
        animationEngine.currentVariant = variant
        let layout = HomeHeaderLayout.make(in: self)
        
        // Feed generic offsets into the search view based on the current variant Context
        searchView.animationConfig.targetContainerTop = (variant == .uae) ? -70 : -40
        
        let logoElement = AnimatableElement(
            view: logoImageView,
            topConstraint: nil, expandedTop: 0, collapsedTop: 0,
            expandedAlpha: 1, collapsedAlpha: 0,
            alphaStartProgress: 0, alphaEndProgress: 0.3
        )
        
        let buildingsElement = AnimatableElement(
            view: backgroundImageView,
            topConstraint: nil,
            expandedTop: 0, collapsedTop: 0,
            secondaryConstraint: backgroundHeightConstraint,
            expandedSecondary: layout.buildingsExpandedHeight, collapsedSecondary: 0,
            expandedAlpha: 1, collapsedAlpha: 0,
            alphaStartProgress: 0, alphaEndProgress: 0.5,
            constraintEndProgress: 0.5
        )
        
        let topCurveElement = AnimatableElement(
            view: topCurveImageView,
            topConstraint: nil, expandedTop: 0, collapsedTop: 0,
            expandedAlpha: 1, collapsedAlpha: 0,
            alphaStartProgress: 0, alphaEndProgress: 0.4,
            hideThreshold: 0.6
        )
        
        
        let bottomCurveElement = AnimatableElement(
            view: bottomCurveImageView,
            topConstraint: bottomCurveTopConstraint,
            expandedTop: layout.bottomCurveExpandedTop, collapsedTop: layout.bottomCurveCollapsedTop,
            secondaryConstraint: bottomCurveHeightConstraint,
            expandedSecondary: layout.bottomCurveExpandedHeight, collapsedSecondary: layout.bottomCurveCollapsedHeight
        )
                
        let tabsElement: AnimatableElement
        var variantElements: [AnimatableElement]
        
        switch variant {
        case .gcc:
            tabsElement = AnimatableElement(
                view: tabsView,
                topConstraint: contentTopConstraint,
                expandedTop: layout.tabsExpandedTop, collapsedTop: layout.tabsCollapsedTopGCC,
                expandedAlpha: 1, collapsedAlpha: 0,
                alphaStartProgress: 0, alphaEndProgress: 0.3,
                hideThreshold: 0.8
            )
            
            let gccSearchElement = AnimatableElement(
                view: searchView,
                topConstraint: searchTopConstraint,
                expandedTop: layout.gccSearchExpandedTop, collapsedTop: layout.gccSearchCollapsedTop
            )
            
            variantElements = [gccSearchElement]
            
        case .uae:
            tabsElement = AnimatableElement(
                view: tabsView,
                topConstraint: contentTopConstraint,
                expandedTop: layout.tabsExpandedTop, collapsedTop: layout.tabsCollapsedTopUAE,
                expandedAlpha: 1, collapsedAlpha: 0,
                alphaStartProgress: 0, alphaEndProgress: 0.8,
                hideThreshold: 0.8
            )
            
            let aiSearchElement = AnimatableElement(
                view: aiSearchView,
                topConstraint: aiSearchTopConstraint,
                expandedTop: layout.aiSearchExpandedTop, collapsedTop: layout.aiSearchCollapsedTop
            )
            
            let dividerElement = AnimatableElement(
                view: dividerLabel,
                topConstraint: nil, expandedTop: 0, collapsedTop: 0,
                expandedAlpha: 1, collapsedAlpha: 0,
                alphaStartProgress: 0, alphaEndProgress: 0.35,
                hideThreshold: 0.5
            )
            
            let searchElement = AnimatableElement(
                view: searchView,
                topConstraint: nil, expandedTop: 0, collapsedTop: 0,
                expandedAlpha: 1, collapsedAlpha: 0,
                alphaStartProgress: 0, alphaEndProgress: 0.35,
                hideThreshold: 0.5
            )
            
            variantElements = [aiSearchElement, dividerElement, searchElement]
        }
        
        animationEngine.elements = [
            logoElement,
            buildingsElement,
            topCurveElement,
            bottomCurveElement,
            tabsElement
        ] + variantElements
    }
    
    func update(progress: CGFloat) {
        let p = min(1, max(0, progress))
        
        animationEngine.apply(progress: p)
        
        searchView.setProgress(p)
        if variant == .uae {
            aiSearchView.setProgress(p)
        }
        
        bottomCurveImageView.image = p > 0.9
            ? UIImage(named: "Home-Header-Bottom-Curve", in: .module, compatibleWith: nil)
            : UIImage(named: "home-header-bottom-curve-uae", in: .module, compatibleWith: nil)
    }
    
    func setCollapsedState(_ isCollapsed: Bool) {
        update(progress: isCollapsed ? 1.0 : 0.0)
    }
}
