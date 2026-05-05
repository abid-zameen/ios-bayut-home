import UIKit

enum RailingCellType {
    case truEstimate
    case truBroker
    case dubaiTransactions
    case commuteSearch
    case bayutGPT
    case findAnAgency
    case mapView
    case dailyRental
}

protocol RailingCardCellViewModelType: AnyObject {
    var headingText: String { get }
    var descriptionText: String { get }
    var backgroundImage: String? { get }
    var backgroundViewColor: UIColor { get }
    var itemImage: String { get }
    var ctaText: String { get }
    var onCTATap: (() -> Void)? { get set }
    var truEstimateConfig: TruEstimateCardConfig? { get }
}

final class RailingCardCellViewModel: RailingCardCellViewModelType {
    let headingText: String
    let descriptionText: String
    let backgroundImage: String?
    let itemImage: String
    let ctaText: String
    let backgroundViewColor: UIColor
    var onCTATap: (() -> Void)?
    let truEstimateConfig: TruEstimateCardConfig?
    
    init(type: RailingCellType) {
        switch type {
        case .truEstimate:
            let variantString = HomeModule.shared.environment.truEstimateVariant
            let variant = TruEstimateABTestVariant(fromRemoteConfig: variantString)
            let config = TruEstimateCardConfig(
                labelText: variant.labelText,
                partialHighlightText: variant.partialHighlightText,
                shouldHighlightEntireText: variant.shouldHighlightEntireText,
                descriptionText: variant.descriptionText,
                shouldHighlightDescription: variant.shouldHighlightDescription,
                descriptionHighlightText: variant.descriptionHighlightText,
                ctaColor: variant.ctaColor,
                ctaViewColor: variant.ctaViewColor
            )
            self.headingText = config.labelText
            self.descriptionText = config.descriptionText
            self.truEstimateConfig = config
            
            self.backgroundImage = "truEstimate_entryPoint_background"
            self.itemImage = "truEstimate_entryPoint_backgroundImage"
            self.backgroundViewColor = .lightGreenBackgroundColor
            self.ctaText = "getStarted".localized()
            
        case .truBroker:
            self.headingText = "truBroker".localized()
            self.descriptionText = "findVerifiedAgents".localized()
            self.backgroundImage = "trubroker_bg"
            self.itemImage = "trubroker_icon"
            self.backgroundViewColor = .white
            self.ctaText = "findAgents".localized()
            self.truEstimateConfig = nil
            
        case .dubaiTransactions:
            self.headingText = "dubaiTransaction".localized()
            self.descriptionText = "entryPointHomeDescription".localized()
            self.backgroundImage = nil
            self.itemImage = "Transactions-Card-Icon"
            self.backgroundViewColor = .green1
            self.ctaText = "start_search".localized()
            self.truEstimateConfig = nil
            
        case .commuteSearch:
            self.headingText = "commuteSearchBannerTitle".localized()
            self.descriptionText = "commuteSearchBannerDescription".localized()
            self.backgroundImage = nil
            self.itemImage = "commuteBannerImage"
            self.backgroundViewColor = .turquoise1
            self.ctaText = "start_search".localized()
            self.truEstimateConfig = nil
            
        case .bayutGPT:
            self.headingText = "BayutGPT"
            self.descriptionText = "Your trusted AI Assitant for UAE Property"
            self.itemImage = "bayutGPTBannerImage"
            self.backgroundImage = nil
            self.backgroundViewColor = .teal1
            self.ctaText = "Start Chatting"
            self.truEstimateConfig = nil
            
        case .findAnAgency:
            self.headingText = "Find an Agency"
            self.descriptionText = "Browse top real estate agencies"
            self.backgroundImage = nil
            self.itemImage = "agency_icon"
            self.backgroundViewColor = .white
            self.ctaText = "Browse"
            self.truEstimateConfig = nil
            
        case .mapView:
            self.headingText = "Map View"
            self.descriptionText = "Explore properties on a map"
            self.backgroundImage = nil
            self.itemImage = "map_icon"
            self.backgroundViewColor = .white
            self.ctaText = "View Map"
            self.truEstimateConfig = nil
            
        case .dailyRental:
            self.headingText = "Daily Rentals"
            self.descriptionText = "Short-term stays for your visit"
            self.backgroundImage = "rentals_bg"
            self.itemImage = "rentals_icon"
            self.backgroundViewColor = .white
            self.ctaText = "Book Now"
            self.truEstimateConfig = nil
        }
    }
}
