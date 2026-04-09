//
//  PrimaryDarkButton.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

enum PrimaryButtonTheme {
    case darkGreen
    case bayutPrimaryGreen
}

class PrimaryDarkButton: UIButton {
    //MARK: - Properties
    var theme: PrimaryButtonTheme = .darkGreen {
        didSet {
            setupForTheme()
        }
    }
    private var defaultBackgroundColor: UIColor = .AppColors.teal5
    private var highlightedBackgroundColor: UIColor = UIColor.AppColors.greenHighlightedColor
    private let scaleHighlightConfiguration = ScaleHighlightConfiguration()
    var cornerRadius: CGFloat = 4
    var font: UIFont = .heading
    
    private var imageAlpha: CGFloat = 1.0
    private var loaderWorkItem: DispatchWorkItem?
    public var isLoading: Bool = false
    var indicator: UIView  = UIActivityIndicatorView()
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setups()
        setupScaleEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setups()
        setupScaleEffect()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            imageView.alpha = imageAlpha
        }
        let newCenter = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        if indicator.center != newCenter {
            indicator.center = newCenter
        }
    }
    
    //MARK: - Configurations
    private func setups(){
        setupForTheme()
        adjustsImageWhenHighlighted = false
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius
    }
    
    private func setupForTheme() {
        switch theme {
        case .darkGreen:
            defaultBackgroundColor = .AppColors.teal5
            highlightedBackgroundColor = .AppColors.greenHighlightedColor
            
        case .bayutPrimaryGreen:
            defaultBackgroundColor = .AppColors.green5
            highlightedBackgroundColor = .AppColors.green2
        }
        
        backgroundColor = defaultBackgroundColor
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
    }
    
    private func setupScaleEffect() {
        addTarget(self, action: #selector(scaleDownEffect), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(scaleUpEffect), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc func scaleDownEffect(){
        let transform: CGAffineTransform = .init(scaleX: scaleHighlightConfiguration.scaleX, y: scaleHighlightConfiguration.scaleY)
        UIView.animate(withDuration: scaleHighlightConfiguration.duration,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: { [weak self] in
            self?.backgroundColor = self?.highlightedBackgroundColor
            self?.transform = transform
        }, completion: nil)
    }
    
    @objc func scaleUpEffect(){
        let transform: CGAffineTransform = .identity
        UIView.animate(withDuration: scaleHighlightConfiguration.duration,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: { [weak self] in
            self?.backgroundColor = self?.defaultBackgroundColor
            self?.transform = transform
        }, completion: nil)
    }
    
    func setupTealColors(){
        defaultBackgroundColor = .AppColors.teal1
        backgroundColor = defaultBackgroundColor
        
        highlightedBackgroundColor = UIColor.AppColors.DTGraphVerticalLine
        
        setTitleColor(.AppColors.teal5, for: .normal)
        setTitleColor(.AppColors.teal5, for: .highlighted)
    }
    
    func setupPrimaryStyle(){
        setups()
    }
    
    func set(defaultColor: UIColor){
        defaultBackgroundColor = defaultColor
        backgroundColor = defaultBackgroundColor
    }
    
    func set(highlightedBackground: UIColor){
        highlightedBackgroundColor = highlightedBackground
    }
    
    func set(textColor: UIColor){
        setTitleColor(textColor, for: .normal)
        setTitleColor(textColor, for: .highlighted)
    }
    
    func showLoader(userInteraction: Bool = false) {
        guard !self.subviews.contains(indicator) else { return }
        let viewsToBeHidden = [titleLabel, imageView]
        // Set up loading indicator and update loading state
        isLoading = true
        self.isUserInteractionEnabled = userInteraction
        //indicator.radius = min(0.7*self.frame.height/2, indicator.radius)
        indicator.alpha = 0.0
        self.addSubview(self.indicator)
        // Clean up
        loaderWorkItem?.cancel()
        loaderWorkItem = nil
        // Create a new work item
        loaderWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                viewsToBeHidden.forEach { view in
                    if view == self.imageView {
                        self.imageAlpha = 0.0
                    }
                    view?.alpha = 0.0
                }
                self.indicator.alpha = 1.0
            }) { _ in
                guard !item.isCancelled else { return }
               // self.isLoading ? self.indicator.startAnimating() : self.hideLoader()
            }
        }
        loaderWorkItem?.perform()
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.subviews.contains(self.indicator) else { return }
            // Update loading state
            self.isLoading = false
            self.isUserInteractionEnabled = true
            //self.indicator.stopAnimating()
            // Clean up
            self.indicator.removeFromSuperview()
            self.loaderWorkItem?.cancel()
            self.loaderWorkItem = nil
            // Create a new work item
            self.loaderWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
                UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
                    self.titleLabel?.alpha = 1.0
                    self.imageView?.alpha = 1.0
                    self.imageAlpha = 1.0
                }) { _ in
                    guard !item.isCancelled else { return }
                }
            }
            self.loaderWorkItem?.perform()
        }
    }
}

