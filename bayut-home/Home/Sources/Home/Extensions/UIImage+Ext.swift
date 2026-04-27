//
//  UIImage+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 22/04/2026.
//

import UIKit

extension UIImage {
    func localized() -> UIImage {
        if Utils.isCurrentLanguageArabic {
            return self.imageFlippedForRightToLeftLayoutDirection()
        }
        return self
    }
}
