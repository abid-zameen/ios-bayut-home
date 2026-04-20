import Foundation

public protocol SellerLeadsBannerActionsDelegate: AnyObject {
    func sellerLeadsBannerDidTap()
}

public struct SellerLeadsBannerActions {
    public weak var delegate: SellerLeadsBannerActionsDelegate?
    
    public init(delegate: SellerLeadsBannerActionsDelegate?) {
        self.delegate = delegate
    }
}
