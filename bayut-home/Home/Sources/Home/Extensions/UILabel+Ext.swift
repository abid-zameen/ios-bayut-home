//
//  UILabel+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//
import UIKit

extension UILabel {
    func labelHeight(width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    func add(lineHeight: CGFloat, font: UIFont? = nil, alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode, numberOfLines: Int = .zero){
        guard let text else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = numberOfLines
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.lineBreakMode = lineBreakMode
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        if let font {
            attributes[.font] = font
        }
        let attributeString = NSMutableAttributedString(string: text, attributes: attributes)
        attributedText = attributeString
    }
    
    func highlight(text: String?, font: UIFont? = nil, color: UIColor? = nil, _ addParagraphStyle: Bool = false, options: NSString.CompareOptions = .caseInsensitive, lineHeightMultiple: CGFloat = 1.25, lineBreakMode: NSLineBreakMode? = nil, alignment: NSTextAlignment? = nil,
                   lineSpacing: CGFloat? = nil, onlyApplyLineBreakMode : Bool = false) {
        guard let fullText = self.text, let target = text else {
            return
        }
        
        let attribText = NSMutableAttributedString(string: fullText)
        let range: NSRange = attribText.mutableString.range(of: target, options: options)
        
        if onlyApplyLineBreakMode, let lineBreakMode {
            self.lineBreakMode = lineBreakMode
        } else {
            self.lineBreakMode = .byWordWrapping
        }
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let color = color {
            attributes[.foregroundColor] = color
        }
        if addParagraphStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            if let lineBreakMode {
                paragraphStyle.lineBreakMode = lineBreakMode
            }
            if let alignment {
                paragraphStyle.alignment = alignment
            }
            if let lineSpacing {
                paragraphStyle.lineSpacing = lineSpacing
            }
            attribText.addAttributes([.paragraphStyle: paragraphStyle],range: attribText.mutableString.range(of: fullText, options: .caseInsensitive))
        }
        
        attribText.addAttributes(attributes, range: range)
        self.attributedText = attribText
    }
    
}
