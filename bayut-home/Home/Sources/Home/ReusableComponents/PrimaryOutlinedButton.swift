//
//  PrimaryOutlinedButton.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 27/11/2025.
//

import UIKit

struct ScaleHighlightConfiguration{
    var duration: TimeInterval = 0.2
    var scaleX: CGFloat = 0.95
    var scaleY: CGFloat = 0.95
}

final class PrimaryOutlinedButton: UIButton {
    
    // MARK: - Properties
    private var defaultBackgroundColor: UIColor = UIColor.white
    private var highlightedBackgroundColor: UIColor = .AppColors.teal1
    private var defaultContentColor: UIColor = UIColor.AppColors.teal5
    private var highlightedContentColor: UIColor = UIColor.AppColors.greenHighlightedColor
    private let scaleHighlightConfiguration = ScaleHighlightConfiguration()
    var font : UIFont = .heading
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Inits
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
    
    private func setups(){
        backgroundColor = UIColor.white
        setTitleColor(defaultContentColor, for: .normal)
        setTitleColor(defaultContentColor, for: .highlighted)
        updateImageColor(color: defaultContentColor)
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.AppColors.teal5.cgColor
        adjustsImageWhenHighlighted = false
        self.titleLabel?.font = font
    }
    private func setupScaleEffect() {
        addTarget(self, action: #selector(scaleDownEffect), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(scaleUpEffect), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    @objc func scaleDownEffect(){
        let transform: CGAffineTransform = .init(scaleX: scaleHighlightConfiguration.scaleX, y: scaleHighlightConfiguration.scaleY)
        UIView.animate(withDuration: scaleHighlightConfiguration.duration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.allowUserInteraction],
                       animations: { [weak self] in
            self?.backgroundColor = self?.highlightedBackgroundColor
            self?.transform = transform
        }, completion: nil)
    }
    
    @objc func scaleUpEffect(){
        let transform: CGAffineTransform = .identity
        UIView.animate(withDuration: scaleHighlightConfiguration.duration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.allowUserInteraction],
                       animations: { [weak self] in
            self?.backgroundColor = self?.defaultBackgroundColor
            self?.transform = transform
        }, completion: nil)
    }
    func applyPrimaryStyle(){
        setups()
    }
    func updateImageColor(color: UIColor){
        let templateImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
        imageView?.image = templateImage
        imageView?.tintColor = color
    }
    func updateTextColor(with color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
    }
    func clearBackGround(){
        defaultBackgroundColor = UIColor.clear
        backgroundColor = defaultBackgroundColor
        highlightedBackgroundColor = UIColor.clear
    }
    func clearBorder(){
        layer.cornerRadius = 0.0
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
    }
    func clearBackgroundAndBorder(){
        clearBackGround()
        clearBorder()
    }
    
    func updateStyle(backgroundColor: UIColor, textColor: UIColor, borderColor: UIColor? = nil, keepBorder: Bool = true, font: UIFont = .heading) {
        defaultBackgroundColor = backgroundColor
        self.backgroundColor = defaultBackgroundColor
        highlightedBackgroundColor = backgroundColor
        self.updateTextColor(with: textColor)
        self.titleLabel?.font = font
        layer.borderColor = keepBorder ? (borderColor ?? UIColor.clear).cgColor : UIColor.clear.cgColor
    }
}
