//
//  UIColor+Ext.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 11/11/2025.
//

import UIKit

extension UIColor {
    struct AppColors {
        static let qualityListerBadgeBackground = UIColor(hex: "#0A2E40").withAlphaComponent(0.5)
        static let qualityListerBadgeBorder = UIColor(hex: "#BCE0F3").withAlphaComponent(0.3)
        static let responsiveBrokerBadgeBackground = UIColor(hex: "#2B0D2E").withAlphaComponent(0.5)
        static let responsiveBrokerBadgeBorder = UIColor(hex: "#DEBFE0").withAlphaComponent(0.3)
        static let grey1 = UIColor(hex: "#F5F5F5")
        static let grey2 = UIColor(hex: "#DBDBDB")
        static let grey3 = UIColor(hex: "#C1BFBF")
        static let grey4 = UIColor(hex: "#A3A1A1")
        static let grey5 = UIColor(hex: "#767676")
        static let grey6 = UIColor(hex: "#4C4A4A")
        static let grey7 = UIColor(hex: "#222222")
        static let green1 = UIColor(hex: "#E9F7F0")
        static let green2 = UIColor(hex: "#BEE7D3")
        static let green3 = UIColor(hex: "#00575E")
        static let green4 = UIColor(hex: "#93D8B5")
        static let green5 = UIColor(hex: "#28B16D")
        static let teal5 = UIColor(hex: "#006169")
        static let forestGreenTeal = UIColor(hex: "#0C4F47")
        static let mediumForestTeal = UIColor(hex: "#1E7167")
        static let limeGreenColor = UIColor(hex: "#CAF4B7")
        static let blackTextColor = UIColor(hex: "#222222")
        static let buttonBorder = UIColor(hex: "#7FAFB3").withAlphaComponent(0.1)
        static let green6 = UIColor(hex: "#145836")
        static let green7 = UIColor(hex: "#249F62")
        static let teal1 = UIColor(hex: "#E5EFF0")
        static let teal2 = UIColor(hex: "#114C6B")
        static let teal4 = UIColor(hex: "#4C9095")
        static let shimmerLightGreenColor = UIColor(hex: "#FAF7F0")
        static let greyBorder = UIColor(hex: "#DEDEDE")
        static let DTGraphVerticalLine = UIColor(hex: "#B2CFD1")
        static let greenHighlightedColor = UIColor(hex: "#004449")
        static let brandColor = UIColor(hex: "#02312C")
        static let secondaryRedColor = UIColor(hex: "#F73131")
        static let turquoiseColor = UIColor(hex: "#0B4C55")
        static let greenGradient1 = UIColor(hex: "#004B55")
        static let greenGradient2 = UIColor(hex: "#169AAC")
        static let orange1 = UIColor(hex: "#FFF2EB")
        static let orange5 = UIColor(hex: "#FF7D3B")
        static let blue1 = UIColor(hex: "#E8F5FB")
        static let blue5 = UIColor(hex: "#2399D8")
        static let blue8 = UIColor(hex: "#114C6B")
        static let blue2 = UIColor(hex: "#1F89C2")
        static let lilac1 = UIColor(hex: "#EBEEFC")
        static let lilac4 = UIColor(hex: "#798AE7")
        static let lilac5 = UIColor(hex: "#4159DD")
        static let turquoise1 = UIColor(hex: "#E7F5F7")
        static let turquoise7 = UIColor(hex: "#0F6C78")
        static let red1 = UIColor(hex: "#FFEAEA")
        static let red5 = UIColor(hex: "#F73131")
        static let purple1 = UIColor(hex: "#F4E9F5")
        static let borderColorLighter: UIColor = UIColor(hex:"#EEEEEE")
        static let lightGreenBackgroundColor = UIColor(hex: "#ECF9F6")
        static let lightDividerColorSecondary = UIColor(hex: "#EFEFEF")
        

        // Advanced Report Theme Colors
        static let teal = UIColor(hex: "#02312C").withAlphaComponent(0.8)
        static let red = UIColor(hex: "#cf2e2e").withAlphaComponent(0.8)
        static let darkGray = UIColor(hex: "#262626").withAlphaComponent(0.8)
        static let orange = UIColor(hex: "#ec7019").withAlphaComponent(0.8)
        static let yellow = UIColor(hex: "#fcb900").withAlphaComponent(0.8)
        static let green = UIColor(hex: "#18b079").withAlphaComponent(0.8)
        static let lightBlue = UIColor(hex: "#0693e3").withAlphaComponent(0.8)
        static let lightPurple = UIColor(hex: "#9b51e0").withAlphaComponent(0.8)
    }
    
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

extension UIColor {
    /**
     Convert RGB value to CMYK value.
     
     - Parameter red: The red value of RGB.
     - Parameter green: The green value of RGB.
     - Parameter blue: The blue value of RGB.
     
     Returns a 4-tuple that represents the CMYK value converted from input RGB.
     */
    public func RGBtoCMYK(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) -> (
        cyan: CGFloat,
        magenta: CGFloat,
        yellow: CGFloat,
        key: CGFloat
    ) {
        // Base case
        if red == 0, green == 0, blue == 0 {
            return (0, 0, 0, 1)
        }
        var cyan = 1 - red
        var magenta = 1 - green
        var yellow = 1 - blue
        let minCMY = min(cyan, magenta, yellow)
        cyan = (cyan - minCMY) / (1 - minCMY)
        magenta = (magenta - minCMY) / (1 - minCMY)
        yellow = (yellow - minCMY) / (1 - minCMY)
        return (cyan, magenta, yellow, minCMY)
    }
    /**
     Convert CMYK value to RGB value.
     
     - Parameter cyan: The cyan value of CMYK.
     - Parameter magenta: The magenta value of CMYK.
     - Parameter yellow: The yellow value of CMYK.
     - Parameter key: The key/black value of CMYK.
     
     Returns a 3-tuple that represents the RGB value converted from input CMYK.
     */
    public func CMYKtoRGB(
        cyan: CGFloat,
        magenta: CGFloat,
        yellow: CGFloat,
        key: CGFloat
    ) -> (
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) {
        let red = (1 - cyan) * (1 - key)
        let green = (1 - magenta) * (1 - key)
        let blue = (1 - yellow) * (1 - key)
        return (red, green, blue)
    }
    /**
     Get the tint color of the current color.
     */
    public func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue)
        let kVal = originCMYK.key > 0.3 ? originCMYK.key - 0.2 : originCMYK.key + 0.2
        let tintRGB = CMYKtoRGB(cyan: originCMYK.cyan, magenta: originCMYK.magenta, yellow: originCMYK.yellow, key: kVal)
        return UIColor(red: tintRGB.red, green: tintRGB.green, blue: tintRGB.blue, alpha: 1.0)
    }
}
