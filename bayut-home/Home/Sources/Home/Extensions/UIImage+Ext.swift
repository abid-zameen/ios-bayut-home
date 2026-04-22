//
//  UIImage+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 22/04/2026.
//

import UIKit

extension UIImage {
    func localized() -> UIImage {
        let isArabic = Locale.current.languageCode == "ar" || Locale.current.identifier.hasPrefix("ar")
        if isArabic {
            return self.imageFlippedForRightToLeftLayoutDirection()
        }
        return self
    }
}
