import Foundation

public enum HomeHeaderTab: String, CaseIterable {
    case properties
    case newProjects
    case transactions
    case agents
    
    public var title: String {
        switch self {
        case .properties:
            return "Properties"
        case .newProjects:
            return "New Projects"
        case .transactions:
            return "Transactions"
        case .agents:
            return "Agents"
        }
    }
}
