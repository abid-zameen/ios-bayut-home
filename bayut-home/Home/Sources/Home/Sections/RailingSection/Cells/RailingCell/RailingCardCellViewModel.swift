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
}

final class RailingCardCellViewModel: RailingCardCellViewModelType {
    let headingText: String
    let descriptionText: String
    let backgroundImage: String?
    let itemImage: String
    let ctaText: String
    let backgroundViewColor: UIColor
    var onCTATap: (() -> Void)?
    
    init(type: RailingCellType) {
        switch type {
        case .truEstimate:
            self.headingText = "truEstimate".localized()
            self.descriptionText = "FindOutYourPropertyWorth".localized()
            self.backgroundImage = "truEstimate_entryPoint_background"
            self.itemImage = "truEstimate_entryPoint_backgroundImage"
            self.backgroundViewColor = .AppColors.lightGreenBackgroundColor
            self.ctaText = "getStarted".localized()
            
        case .truBroker:
            self.headingText = "truBroker".localized()
            self.descriptionText = "findVerifiedAgents".localized()
            self.backgroundImage = "trubroker_bg"
            self.itemImage = "trubroker_icon"
            self.backgroundViewColor = .white
            self.ctaText = "findAgents".localized()
            
        case .dubaiTransactions:
            self.headingText = "dubaiTransaction".localized()
            self.descriptionText = "entryPointHomeDescription".localized()
            self.backgroundImage = nil
            self.itemImage = "Transactions-Card-Icon"
            self.backgroundViewColor = .AppColors.green1
            self.ctaText = "start_search".localized()
            
        case .commuteSearch:
            self.headingText = "Search 2.0"
            self.descriptionText = "Find a homes by commute time"
            self.backgroundImage = nil
            self.itemImage = "commuteBannerImage"
            self.backgroundViewColor = .AppColors.turquoise1
            self.ctaText = "Search Now"
            
        case .bayutGPT:
            self.headingText = "BayutGPT"
            self.descriptionText = "Your trusted AI Assitant for UAE Property"
            self.itemImage = "bayutGPTBannerImage"
            self.backgroundImage = nil
            self.backgroundViewColor = .AppColors.teal1
            self.ctaText = "Start Chatting"
            
        case .findAnAgency:
            self.headingText = "Find an Agency"
            self.descriptionText = "Browse top real estate agencies"
            self.backgroundImage = nil
            self.itemImage = "agency_icon"
            self.backgroundViewColor = .white
            self.ctaText = "Browse"
            
        case .mapView:
            self.headingText = "Map View"
            self.descriptionText = "Explore properties on a map"
            self.backgroundImage = nil
            self.itemImage = "map_icon"
            self.backgroundViewColor = .white
            self.ctaText = "View Map"
            
        case .dailyRental:
            self.headingText = "Daily Rentals"
            self.descriptionText = "Short-term stays for your visit"
            self.backgroundImage = "rentals_bg"
            self.itemImage = "rentals_icon"
            self.backgroundViewColor = .white
            self.ctaText = "Book Now"
        }
    }
}
