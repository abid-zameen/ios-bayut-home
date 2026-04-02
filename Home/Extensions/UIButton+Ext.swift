//
//  UIButton+Ext.swift
//  TruEstimate
//
//  Created by Zain Najam Khan on 18/11/2025.
//

import Foundation
import UIKit

extension UIButton {
    func applyButtonGradient(colors: [CGColor],
                             locations: [NSNumber]? = nil,
                             startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                             endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradient, at: 0)
        layer.masksToBounds = true
    }
    
    enum ButtonConfigurationStyle {
        case plain
        case filled
        case bordered
        case borderedProminent
    }
    
    func applyButtonConfiguration(
        title: String,
        iconName: String? = nil,
        font: UIFont,
        titleColor: UIColor,
        iconColor: UIColor? = .black,
        imagePlacement: NSDirectionalRectEdge = .leading,
        imagePadding: CGFloat = 8,
        style: ButtonConfigurationStyle = .plain,
        cornerStyle: UIButton.Configuration.CornerStyle? = nil,
        cornerRadius: CGFloat? = nil,
        backgroundColor: UIColor? = nil
    ) {
        var container = AttributeContainer()
        container.font = font
        container.foregroundColor = titleColor
        
        var config: UIButton.Configuration
        switch style {
        case .filled:
            config = .filled()
        case .bordered:
            config = .bordered()
        case .borderedProminent:
            config = .borderedProminent()
        default:
            config = .plain()
        }
        
        config.attributedTitle = AttributedString(title, attributes: container)
        if let cornerStyle {
            config.cornerStyle = cornerStyle
        }
        
        if let cornerRadius {
            config.background.cornerRadius = cornerRadius
        }
        
        if let backgroundColor {
            config.baseBackgroundColor = backgroundColor
        }
        
        if let iconName,
           let image = UIImage(named: iconName, in: .main, with: nil)?
            .withRenderingMode(.alwaysTemplate) {
            
            config.image = image
            config.imagePlacement = imagePlacement
            config.imagePadding = imagePadding
            config.baseForegroundColor = iconColor
        }
        
        self.configuration = config
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
