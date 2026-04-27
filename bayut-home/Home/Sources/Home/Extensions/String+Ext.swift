//
//  String+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//
import UIKit
import Foundation

extension String {
    static let empty = ""
    static let whiteSpace = " "
    
    func makeBold(text: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let nsString = self as NSString
        let range = nsString.range(of: text)
        if range.location != NSNotFound {
            attributedString.addAttributes([.font: font], range: range)
        }
        return attributedString
    }
    
    func localized() -> String {
        return NSLocalizedString(self, bundle: .module, comment: "")
    }
}
