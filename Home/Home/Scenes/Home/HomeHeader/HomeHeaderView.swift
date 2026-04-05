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
        iv.image = UIImage(named: "Home-Buildings")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let topCurveImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Header-Top-Curve")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let bottomCurveImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home-Header-Bottom-Curve")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bayut_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    } ()
    
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
    
    private var logoHeightConstraint: NSLayoutConstraint?
    private var logoTopConstraint: NSLayoutConstraint?
    private var contentTopConstraint: NSLayoutConstraint?
    
    // Independent Search Constraints
    private var aiSearchTopConstraint: NSLayoutConstraint?
    private var searchTopConstraint: NSLayoutConstraint?
    private var dividerTopConstraint: NSLayoutConstraint?
    
    // Background Constraints
    private var backgroundHeightConstraint: NSLayoutConstraint?
    private var backgroundTopConstraint: NSLayoutConstraint?
    private var bottomCurveHeightConstraint: NSLayoutConstraint?
    private var bottomCurveTopConstraint: NSLayoutConstraint?
    
    var isGCCVariant: Bool = false {
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
        
        logoHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 38)
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 90)
        
        bottomCurveTopConstraint = bottomCurveImageView.topAnchor.constraint(equalTo: topAnchor, constant: 178)
        
        backgroundHeightConstraint = backgroundImageView.heightAnchor.constraint(equalToConstant: 114)
        backgroundTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 64)
        
        // Horizontal pinning as per XIB
        NSLayoutConstraint.activate([
            backgroundTopConstraint!,
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 284),
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
        
        // Correct height as per XIB
        bottomCurveHeightConstraint = bottomCurveImageView.heightAnchor.constraint(equalToConstant: 97)
        bottomCurveHeightConstraint?.isActive = true
        
        // Independent Top constraints as per XIB relative to header topAnchor
        contentTopConstraint = contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 165)
        
        // RELATIVE Vertical Chain for stable spacing
        // Increased gaps for a more breathable layout
        aiSearchTopConstraint = aiSearchView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 12)
        dividerTopConstraint = dividerLabel.topAnchor.constraint(equalTo: aiSearchView.bottomAnchor, constant: 8)
        searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 8)
        
        // Definitive Overlay Fix (Pin bottom-most view to header bottom)
        let bottomPin = searchView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        bottomPin.priority = .defaultLow // Allow height shrinkage during scroll
        bottomPin.isActive = true
        
        // Horizontal components
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            aiSearchView.centerXAnchor.constraint(equalTo: centerXAnchor),
            aiSearchView.widthAnchor.constraint(equalToConstant: 343),
            
            dividerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        contentTopConstraint?.isActive = true
        
        setupLayout()
    }
    
    private func setupLayout() {
        // This stack will now only hold tabs or minor elements
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStackView.spacing = 16
        contentStackView.addArrangedSubview(tabsView)
        
        updateConstraintsForVariant()
    }
    
    private func updateConstraintsForVariant() {
        aiSearchTopConstraint?.isActive = !isGCCVariant
        dividerTopConstraint?.isActive = !isGCCVariant
        
        aiSearchView.isHidden = isGCCVariant
        dividerLabel.isHidden = isGCCVariant
        
        if isGCCVariant {
            searchTopConstraint?.isActive = false
            // Decoupled: Pin directly to topAnchor (165 Tabs + 36 Height + 16 Gap = 217)
            searchTopConstraint = searchView.topAnchor.constraint(equalTo: topAnchor, constant: 217)
            searchTopConstraint?.isActive = true
        } else {
            searchTopConstraint?.isActive = false
            searchTopConstraint = searchView.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 8)
            searchTopConstraint?.isActive = true
        }
    }
    
    // MARK: - Animation Support
    func update(with offset: CGFloat) {
        let stickyHeight: CGFloat = 140
        let maxCollapseOffset: CGFloat = 120 // Duration of internal transitions
        let progress = min(1, max(0, offset / maxCollapseOffset))
        
        let fadeProgress = min(1, progress / 0.8)
        let alpha = 1 - fadeProgress
        
        logoImageView.alpha = alpha
        backgroundImageView.alpha = alpha
        tabsView.alpha = alpha
        topCurveImageView.alpha = alpha
        
        // Early hiding of background and supplementary elements
        let shouldHide = progress > 0.5
        backgroundImageView.isHidden = shouldHide
        logoImageView.isHidden = shouldHide
        topCurveImageView.isHidden = shouldHide
        tabsView.isHidden = shouldHide
        
        // Animate Logo shrinking
        let initialLogoTop: CGFloat = 90
        let initialLogoHeight: CGFloat = 38
        logoHeightConstraint?.constant = initialLogoHeight * alpha
        logoTopConstraint?.constant = initialLogoTop * alpha
        
        // Animate Building Image shrinking (New)
        let initialBackgroundTop: CGFloat = 64
        let initialBackgroundHeight: CGFloat = 114
        backgroundHeightConstraint?.constant = initialBackgroundHeight * alpha
        backgroundTopConstraint?.constant = initialBackgroundTop * alpha
        
        // Sticky Green Background (Bottom Curve) Position & Height Animation
        // Expanded: y=178, h=97 | Collapsed: y=-20, h=140
        let initialCurveTop: CGFloat = 178
        let collapsedCurveTop: CGFloat = -20
        bottomCurveTopConstraint?.constant = initialCurveTop + (collapsedCurveTop - initialCurveTop) * progress
        
        let expandedCurveHeight: CGFloat = 97
        let stickyCurveHeight: CGFloat = 140
        bottomCurveHeightConstraint?.constant = expandedCurveHeight + (stickyCurveHeight - expandedCurveHeight) * progress
        
        if !isGCCVariant {
            dividerLabel.alpha = alpha
            dividerLabel.isHidden = shouldHide
            aiSearchView.setProgress(progress)
            
            // INDEPENDENT TOP ANIMATION (XIB Alignment)
            // Initial offset 165 (Tabs Start) -> Collapsed end height 140
            let initialTop: CGFloat = 165
            let stickyYOffset: CGFloat = -115 // Adjusted to keep target around y=71
            contentTopConstraint?.constant = initialTop + (stickyYOffset) * progress
            
            searchView.alpha = alpha
            searchView.isHidden = shouldHide
        } else {
            searchView.setProgress(progress)
            
            // Decoupled GCC Animation
            // Initial Top 217 (165 + 36 + 16)
            let initialTop: CGFloat = 217
            let stickyYOffset: CGFloat = -170 // You can now adjust this -160 freely!
            searchTopConstraint?.constant = initialTop + (stickyYOffset) * progress
            
            // Also move the tabs in background
            let initialTabsTop: CGFloat = 165
            let tabsStickyYOffset: CGFloat = -130
            contentTopConstraint?.constant = initialTabsTop + (tabsStickyYOffset) * progress
        }
    }
    
    func setCollapsedState(_ isCollapsed: Bool) {
        update(with: isCollapsed ? 120 : 0)
    }
}
