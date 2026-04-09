//
//  Foundation+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//

import Foundation
import UIKit

extension Double {
    func convertToDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Date {
    var quarter: Int {
        return (Calendar.current.component(.month, from: self) - 1) / 3 + 1
    }
    
    var yearInt: Int {
        return Calendar.current.component(.year, from: self)
    }
}

extension String {
    func makeBold(text: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let nsString = self as NSString
        let range = nsString.range(of: text)
        if range.location != NSNotFound {
            attributedString.addAttributes([.font: font], range: range)
        }
        return attributedString
    }
}
