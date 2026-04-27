//
//  Utils.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//
import Foundation

final class Utils {
    static let isCurrentLanguageArabic: Bool = Locale.current.languageCode == "ar" || Locale.current.identifier.hasPrefix("ar")
}
