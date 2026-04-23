import Foundation

struct HomeHeaderSearchViewModel {
    let firstButtonTitle: String
    let secondButtonTitle: String
    let searchPlaceholder: String
    let showButtonsView: Bool
    
    init(selectedTab: HomeHeaderTab) {
        switch selectedTab {
        case .properties:
            firstButtonTitle = "buy".localized()
            secondButtonTitle = "rent".localized()
            searchPlaceholder = "searchLocation".localized()
            showButtonsView = true
            
        case .newProjects:
            firstButtonTitle = ""
            secondButtonTitle = ""
            searchPlaceholder = "searchLocation".localized()
            showButtonsView = false
            
        case .transactions:
            firstButtonTitle = "sold".localized()
            secondButtonTitle = "txt_text_rented".localized()
            searchPlaceholder = "str_dt_search_location".localized()
            showButtonsView = true
            
        case .agents:
            firstButtonTitle = "buy".localized()
            secondButtonTitle = "rent".localized()
            searchPlaceholder = "searchByAgentNameOrLocation".localized()
            showButtonsView = true
        }
    }
}
