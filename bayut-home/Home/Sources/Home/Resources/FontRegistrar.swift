//
//  FontRegistrar.swift
//  HomePackage
//
//  Created by Hammad Shahid on 07/04/2026.
//


import Foundation
import CoreText
import UIKit

public struct FontRegistrar {
    public static func registerPackageFonts() {
        // List the EXACT filenames of your fonts here (without the .ttf extension)
        let fontFilenames = [
            "Lato-Regular", "Lato-Bold", "Lato-Light", "Lato-Medium", "Lato-SemiBold"
        ]
        
        for name in fontFilenames {
            // Tell it to look in Bundle.module (the package bundle)
            guard let fontURL = Bundle.module.url(forResource: name, withExtension: "ttf") else {
                print("Failed to find font \(name) in HomePackage.")
                continue
            }
            
            var error: Unmanaged<CFError>?
            // Register it temporarily for this run of the app
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        }
    }
}
