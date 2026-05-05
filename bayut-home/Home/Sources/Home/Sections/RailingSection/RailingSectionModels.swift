//
//  RailingSectionModels.swift
//  Home
//
//  Created by Hammad Shahid on 04/05/2026.
//
import UIKit
import BayutUIKit

struct TruEstimateCardConfig {
    let labelText: String
    let partialHighlightText: String?
    let shouldHighlightEntireText: Bool
    let descriptionText: String
    let shouldHighlightDescription: Bool
    let descriptionHighlightText: String?
    let ctaColor: UIColor
    let ctaViewColor: UIColor
}

enum TruEstimateABTestVariant {
    case variant2
    case variant3
    case standard
    
    var labelText: String {
        switch self {
        case .variant2, .variant3:
            return "findValueOfProperty".localized()
        case .standard:
            return "truEstimate".localized()
        }
    }
    
    var shouldHighlightEntireText: Bool {
         switch self {
         case .variant2, .variant3:
             return true
         case .standard:
             return false
         }
     }
     
     var partialHighlightText: String? {
         switch self {
         case .standard:
             return "estimate".localized()
         case .variant2, .variant3:
             return nil
         }
     }
    
    var descriptionText: String {
        switch self {
        case .variant2:
            return "propertyWorthForFree".localized()
        case .variant3:
            return "propertyWorthWithExpertData".localized()
        case .standard:
            return "FindOutYourPropertyWorth".localized()
        }
    }
    
    var shouldHighlightDescription: Bool {
        switch self {
        case .variant2:
            return true
        case .variant3, .standard:
            return false
        }
    }
    
    var descriptionHighlightText: String? {
        switch self {
        case .variant2:
            return "estimate".localized()
        case .variant3, .standard:
            return nil
        }
    }
    
    var ctaColor: UIColor {
        switch self {
        case .variant2:
            return .white
        case .variant3, .standard:
            return .turquoiseColor
        }
    }

    var ctaViewColor: UIColor {
        switch self {
        case .variant2:
            return .teal5
        case .variant3, .standard:
            return .white
        }
    }
    
    init(fromRemoteConfig string: String) {
          switch string {
          case "truestimate_home_value":
              self = .variant2
          case "truestimate_property_value":
              self = .variant3
          default:
              self = .standard
          }
      }
}
