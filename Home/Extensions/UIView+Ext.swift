//
//  UIView+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 31/03/2026.
//
import UIKit

extension UIView {
    
    // MARK: - Properties
    class var reuseId: String {
        String(describing: Self.self)
    }
    
    @objc
    func configure(with viewModel: Any) {
        // An optional implementation.
        // Must be implemented if `viewModel` has to be configured.
        assertionFailure("configure(with viewModel: Any) needs to be overriden")
    }
    
    func setRoundedCorner(radius value: CGFloat, maskedCorners: CACornerMask? = nil) {
        self.layer.cornerRadius = value
        if let maskedCorners = maskedCorners {
            self.layer.maskedCorners = maskedCorners
        }
        self.clipsToBounds = true
    }
    
    func setGradient(colors: [CGColor], angle: Float = 0, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, locations: [NSNumber]? = nil, type: CAGradientLayerType? = nil) {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors
        if let locations {
            gradient.locations = locations
        }
        if let type {
            gradient.type = type
        }
        if let startPoint, let endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        } else {
            let alpha: Float = angle / 360
            let startPointX = powf(
                sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
                2
            )
            let startPointY = powf(
                sinf(2 * Float.pi * ((alpha + 0) / 2)),
                2
            )
            let endPointX = powf(
                sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
                2
            )
            let endPointY = powf(
                sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
                2
            )
            gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
            gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    func updateGradientLayerFrame(){
        let allSubLayers = layer.sublayers ?? []
        for sublayer in allSubLayers {
            if let gradientLayer = sublayer as? CAGradientLayer {
                gradientLayer.frame = bounds
                break
            }
        }
    }
    
    func setRoundedWithRespectToHeight(shouldClipToBounds: Bool = true){
        layer.cornerRadius = frame.size.height / 2
        if shouldClipToBounds {
            clipsToBounds = true
        }
    }
    
    func sketchShadow(shadowColor: UIColor = UIColor.gray, height: CGFloat = 0, shadowOpacity: Float = 0.35, shadowRadius: CGFloat = 5.0) {
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: height)
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    
    func setBorder(_ color:UIColor, width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }

}
