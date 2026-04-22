import Foundation

public enum HomeHeaderTab: String, CaseIterable {
    case properties
    case newProjects
    case transactions
    case agents
    
    public var title: String {
        switch self {
        case .properties:
            return "properties".localized()
        case .newProjects:
            return "newProjectHeadingHome".localized()
        case .transactions:
            return "dldTransactions".localized()
        case .agents:
            return "agents".localized()
        }
    }
}
