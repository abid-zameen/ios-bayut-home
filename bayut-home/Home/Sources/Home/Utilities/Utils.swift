//
//  Utils.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//
import Foundation

final class Utils {
    static let isCurrentLanguageArabic: Bool = Locale.current.languageCode == "ar" || Locale.current.identifier.hasPrefix("ar")
    
    static func getFormattedPriceStringWithCurrency(price: Any) -> String {
        return "\(HomeModule.shared.environment.selectedCurrency) \(getFormattedPrice(price: price))"
    }
    
    static func getAreaFromSqft(area: Any) -> String? {
        HomeModule.shared.utilities.getAreaFromSqftWithSelectedUnit(area: area)
    }
    
    static func getFormattedPrice(price: Any) -> String {
        let priceValue = HomeModule.shared.utilities.getConvertedPrice(price: price)
        return formatPrice(priceValue)
    }
    
    static func priceShortStringRepresentationWithoutDecimal(price: Double?) -> String {
        HomeModule.shared.utilities.priceShortStringRepresentationWithoutDecimal(price: price)
    }
    
    private static func formatPrice(_ price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = .empty
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: price)) ?? .empty
    }
}
