import Foundation

public struct MarketingBannerConfig: Codable {
    public let isEnabled: Bool
    public let index: Int
    public let bannerImageUrl: String
    
    public init(isEnabled: Bool, index: Int, bannerImageUrl: String) {
        self.isEnabled = isEnabled
        self.index = index
        self.bannerImageUrl = bannerImageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case index = "index"
        case bannerImageUrl = "banner_image_url"
    }
}
