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
    
    private let bottomCurveGradientImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home-header-bottom-curve-uae", in: .module, compatibleWith: nil)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let bottomCurveSolidImageView: UIImageView = {
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
    
    private var hasSetupElementsInWindow = false
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, !hasSetupElementsInWindow else { return }
        hasSetupElementsInWindow = true
        // Re-compute animation positions with real safe area insets
        setupElements()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = false
        
        addSubview(backgroundImageView)
        addSubview(topCurveImageView)
        addSubview(bottomCurveSolidImageView)
        addSubview(bottomCurveGradientImageView)
        addSubview(logoImageView)
        addSubview(contentStackView)
        addSubview(aiSearchView)
        addSubview(dividerLabel)
        addSubview(searchView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        topCurveImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomCurveGradientImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomCurveSolidImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        aiSearchView.translatesAutoresizingMaskIntoConstraints = false
        dividerLabel.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        logoHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: HomeHeaderLayout.ViewHeight.logo)
        
        let initialLayout = HomeHeaderLayout.make(in: self)
        
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.logoExpandedTop)
        bottomCurveTopConstraint = bottomCurveGradientImageView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.bottomCurveExpandedTop)
        backgroundHeightConstraint = backgroundImageView.heightAnchor.constraint(equalToConstant: HomeHeaderLayout.ViewHeight.buildings)
        backgroundTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.buildingsExpandedTop)
        
        guard let backgroundTopConstraint, let backgroundHeightConstraint, let logoHeightConstraint, let logoTopConstraint, let bottomCurveTopConstraint else { return }
                
        NSLayoutConstraint.activate([
            backgroundTopConstraint,
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundHeightConstraint,
            
            topCurveImageView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.statusBarHeight + 57),
            topCurveImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCurveImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCurveImageView.heightAnchor.constraint(equalToConstant: 125),
            
            bottomCurveGradientImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCurveGradientImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomCurveSolidImageView.topAnchor.constraint(equalTo: bottomCurveGradientImageView.topAnchor),
            bottomCurveSolidImageView.leadingAnchor.constraint(equalTo: bottomCurveGradientImageView.leadingAnchor),
            bottomCurveSolidImageView.trailingAnchor.constraint(equalTo: bottomCurveGradientImageView.trailingAnchor),
            bottomCurveSolidImageView.bottomAnchor.constraint(equalTo: bottomCurveGradientImageView.bottomAnchor),
            
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 154),
            logoHeightConstraint,
            logoTopConstraint,
            bottomCurveTopConstraint
        ])
        
        bottomCurveHeightConstraint = bottomCurveGradientImageView.heightAnchor.constraint(equalToConstant: initialLayout.bottomCurveExpandedHeight)
        bottomCurveHeightConstraint?.isActive = true
        
        contentTopConstraint = contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.tabsExpandedTop)
        aiSearchTopConstraint = aiSearchView.topAnchor.constraint(equalTo: topAnchor, constant: initialLayout.aiSearchExpandedTop)
        dividerTopConstraint = dividerLabel.topAnchor.constraint(equalTo: aiSearchView.bottomAnchor, constant: 8)
        searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: -8)
        
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
        
        searchView.onSearchTapped = { [weak self] in
            guard let self = self else { return }
            self.onSearchTapped?(self.currentTab, self.searchView.selectedPurpose)
        }
        
        searchView.onHeightChanged = { [weak self] in
            self?.onHeaderHeightChanged?()
        }
        
        setupLayout()
    }
    
    var visibleContentBottom: CGFloat {
        layoutIfNeeded()
        let subviewBottoms = subviews.map { $0.frame.maxY }
        return (subviewBottoms.max() ?? frame.height)
    }
    
    /// Computes the expanded header content height from constraint constants
    /// rather than from frame measurements, to avoid feedback loops.
    var expandedContentHeight: CGFloat {
        let layout = HomeHeaderLayout.make(in: self)
        
        if variant == .gcc {
            // In GCC, searchView top is relative to the header top
            return layout.gccSearchExpandedTop + searchView.contentHeight
        } else {
            // In UAE, searchView top is relative to the dividerLabel
            let aiBottom = layout.aiSearchExpandedTop + HomeHeaderLayout.ViewHeight.aiSearch
            let dividerHeight: CGFloat = 16
            let dividerBottom = aiBottom + dividerHeight
            let searchViewTop = dividerBottom - 8
            return searchViewTop + searchView.contentHeight
        }
    }

    
    private func setupLayout() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStackView.spacing = 16
        contentStackView.addArrangedSubview(tabsView)
        
        let uaeTabs: [HomeHeaderTab] = [.properties, .newProjects, .transactions, .agents]
        tabsView.setupTabs(tabs: uaeTabs)
        
        tabsView.onTabSelected = { [weak self] tab in
            self?.handleTabSelection(tab)
        }
        
        updateConstraintsForVariant()
        setupElements()
    }
    
    private var currentTab: HomeHeaderTab = .properties
    var onSearchTapped: ((HomeHeaderTab, HomePurpose) -> Void)?
    var onHeaderHeightChanged: (() -> Void)?
    
    private func handleTabSelection(_ tab: HomeHeaderTab) {
        self.currentTab = tab
        let shouldShowButtons = (tab != .newProjects)
        searchView.showPurposeButtons(shouldShowButtons)
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
            searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: -8)
            searchTopConstraint?.isActive = true
            aiSearchTopConstraint?.isActive = true
        }
    }
    
    private func setupElements() {
        animationEngine.currentVariant = variant
        let layout = HomeHeaderLayout.make(in: self)
        
        searchView.animationConfig.targetContainerTop = (variant == .uae) ? -70 : -50
        
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
        
        
        let bottomCurveGradientElement = AnimatableElement(
            view: bottomCurveGradientImageView,
            topConstraint: bottomCurveTopConstraint,
            expandedTop: layout.bottomCurveExpandedTop, collapsedTop: layout.bottomCurveCollapsedTop,
            secondaryConstraint: bottomCurveHeightConstraint,
            expandedSecondary: layout.bottomCurveExpandedHeight, collapsedSecondary: layout.bottomCurveCollapsedHeight,
            expandedAlpha: (variant == .uae) ? 1 : 0,
            collapsedAlpha: 0,
            alphaStartProgress: 0.8, alphaEndProgress: 1.0
        )
        
        let bottomCurveSolidElement = AnimatableElement(
            view: bottomCurveSolidImageView,
            topConstraint: nil, // Moves with the gradient one via AutoLayout
            expandedTop: 0, collapsedTop: 0,
            expandedAlpha: (variant == .uae) ? 0 : 1,
            collapsedAlpha: 1,
            alphaStartProgress: 0.8, alphaEndProgress: 1.0
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
                alphaStartProgress: 0, alphaEndProgress: 0.3,
                hideThreshold: 0.4
            )
            
            let searchElement = AnimatableElement(
                view: searchView,
                topConstraint: nil, expandedTop: 0, collapsedTop: 0,
                expandedAlpha: 1, collapsedAlpha: 0,
                alphaStartProgress: 0.1, alphaEndProgress: 0.4,
                hideThreshold: 0.5
            )
            
            variantElements = [aiSearchElement, dividerElement, searchElement]
        }
        
        animationEngine.elements = [
            logoElement,
            buildingsElement,
            topCurveElement,
            bottomCurveGradientElement,
            bottomCurveSolidElement,
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
    }
    
    func setCollapsedState(_ isCollapsed: Bool) {
        update(progress: isCollapsed ? 1.0 : 0.0)
    }
}
