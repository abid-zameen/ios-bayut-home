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

    class func loadFromNib<T: UIView>(_ bundle: Bundle = .main) -> T {
        let nibs = bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)
        return nibs![0] as! T
    }

    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func applyAnimatedGradientBorder(
        colors: [UIColor],
        lineWidth: CGFloat = 4.0,
        cornerRadius: CGFloat = 12.0
    ) {
        
        layer.sublayers?.removeAll(where: { $0.name == "animatedGradientBorder" })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "animatedGradientBorder"
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0].map { NSNumber(value: $0) }
        
        let shape = CAShapeLayer()
        
        shape.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: cornerRadius
        ).cgPath
        shape.lineWidth = lineWidth
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        
        gradientLayer.mask = shape
        
        let animationDuration: CFTimeInterval = 4.0
        
        let startPointValues: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0)
        ]
        
        let endPointValues: [CGPoint] = [
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0)
        ]
        
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = startPointValues
        startPointAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0].map { NSNumber(value: $0) }
        startPointAnimation.duration = animationDuration
        startPointAnimation.repeatCount = 1
        startPointAnimation.calculationMode = .linear
        
        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = endPointValues
        endPointAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0].map { NSNumber(value: $0) }
        endPointAnimation.duration = animationDuration
        endPointAnimation.repeatCount = 1
        endPointAnimation.calculationMode = .linear
        gradientLayer.add(startPointAnimation, forKey: "shimmerStartPoint")
        gradientLayer.add(endPointAnimation, forKey: "shimmerEndPoint")
        
        layer.addSublayer(gradientLayer)
    }

}
