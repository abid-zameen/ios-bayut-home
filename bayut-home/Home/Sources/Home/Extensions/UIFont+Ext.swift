//
//  UIFont+Ext.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 11/11/2025.
//

import Foundation
import UIKit

extension UIFont {
    
    static func heading2() -> UIFont {
        return UIFont.appBoldFont(ofSize: 16)
    }
    static let bodyL7: UIFont = UIFont.appRegularFont(ofSize: 28)
    static let bodyL6: UIFont = UIFont.appRegularFont(ofSize: 26)
    static let bodyL5: UIFont = UIFont.appRegularFont(ofSize: 24)
    static let bodyL4: UIFont = UIFont.appRegularFont(ofSize: 22)
    static let bodyL3: UIFont = UIFont.appRegularFont(ofSize: 20)
    static let bodyL2: UIFont = UIFont.appRegularFont(ofSize: 18)
    static let bodyL1: UIFont = UIFont.appRegularFont(ofSize: 16)
    static let body: UIFont = UIFont.appRegularFont(ofSize: 14)
    static let bodyS1: UIFont = UIFont.appRegularFont(ofSize: 12)
    static let bodyS2: UIFont = UIFont.appRegularFont(ofSize: 10)
    static let bodyS3: UIFont = UIFont.appRegularFont(ofSize: 13)
    static let mediumBody: UIFont = UIFont.appMediumFont(ofSize: 14)
    
    static let boldBodyS1: UIFont = UIFont.appBoldFont(ofSize: 12)
    static let boldBody: UIFont = UIFont.appBoldFont(ofSize: 14)
    static let semiBoldBody: UIFont = UIFont.appSemiBoldFont(ofSize: 14)
    static let semiBoldHeading: UIFont = UIFont.appSemiBoldFont(ofSize: 16)
    static let semiBoldBodyS1: UIFont = UIFont.appSemiBoldFont(ofSize: 12)
    
    static let bodyL0: UIFont = UIFont.appRegularFont(ofSize: 14)
    static let body0: UIFont = UIFont.appRegularFont(ofSize: 12)
    
    static let heading: UIFont = UIFont.appBoldFont(ofSize: 16)
    static let headingL1: UIFont = UIFont.appBoldFont(ofSize: 18)
    static let headingL20: UIFont = UIFont.appBoldFont(ofSize: 20)
    static let headingL2: UIFont = UIFont.appBoldFont(ofSize: 22)
    static let headingL3: UIFont = UIFont.appBoldFont(ofSize: 24)
    static let headingL4: UIFont = UIFont.appBoldFont(ofSize: 14)
    static let headingL6 : UIFont = UIFont.appBoldFont(ofSize: 12)
    static let headingL5: UIFont = UIFont.appMediumFont(ofSize: 14)
    static let headingL7: UIFont = UIFont.appMediumFont(ofSize: 16)
    static let headingS1: UIFont = UIFont.appBoldFont(ofSize: 10)
    
    static func headingRegular() -> UIFont {
        return UIFont.appRegularFont(ofSize: 15)
    }
    
    static func textField() -> UIFont {
        return UIFont.appRegularFont(ofSize: 14)
    }
    
    static func titleRegular() -> UIFont {
        return UIFont.appRegularFont(ofSize: 16)
    }
    
    static func superScript() -> UIFont {
        return UIFont.appRegularFont(ofSize: 10)
    }
    
    static func button() -> UIFont {
        return UIFont.appRegularFont(ofSize: 16)
    }
    
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
    
    @objc class func appRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontNames.Regular, size: size)!
    }
    
    @objc class func appMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontNames.Medium, size: size)!
    }
    
    @objc class func appBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontNames.Bold, size: size)!
    }
    
    @objc class func appLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontNames.Light, size: size)!
    }
    
    @objc class func appSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontNames.SemiBold, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontNames.Regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontNames.Bold
        case "CTFontObliqueUsage":
            fontName = AppFontNames.Light
        default:
            fontName = AppFontNames.Regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(appRegularFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(appMediumFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(appBoldFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(appLightFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

struct AppFontNames {
    static let Regular: String = "Lato-Regular"
    static let Bold: String = "Lato-Bold"
    static let Light: String = "Lato-Light"
    static let Medium: String = "Lato-Medium"
    static let SemiBold: String = "Lato-SemiBold"
}


extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func clean(precision: Int? = nil) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : (precision != nil ? String(format: "%.\(precision ?? 0)f", self) : String(self))
    }
}
