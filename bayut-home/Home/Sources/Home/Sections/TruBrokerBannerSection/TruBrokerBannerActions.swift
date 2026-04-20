import Foundation

public protocol TruBrokerBannerActionsDelegate: AnyObject {
    func truBrokerBannerDidTap()
}

public struct TruBrokerBannerActions {
    public weak var delegate: TruBrokerBannerActionsDelegate?
    
    public init(delegate: TruBrokerBannerActionsDelegate?) {
        self.delegate = delegate
    }
}
