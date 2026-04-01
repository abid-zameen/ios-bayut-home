//
//  TruBrokerBannerSection.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

// MARK: - Identifier
enum TruBrokerBannerSectionId: String, SectionIdentifier {
    case main = "truBrokerBanner"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Section Descriptor
final class TruBrokerBannerSection: SectionDescriptor {
    typealias Identifier = TruBrokerBannerSectionId
    
    let identifier: TruBrokerBannerSectionId = .main
    
    // MARK: - Item
    struct Item: Hashable {
        let id: String = "truBroker_banner_unique_id" // Only one static identity needed per banner
    }
    
    // MARK: - Build Items
    func buildItems() -> [Item] {
        // Single cell driving the banner
        [Item()]
    }
    
    // MARK: - Layout Configuration
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // 16 px spacing around all sides as requested
        return .fullWidthList(
            estimatedHeight: 100, // Estimated starting height for self-sizing
            sectionInsets: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        )
    }
    
    // MARK: - Cell Rendering
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TruBrokerBannerCell.reuseId, for: indexPath
        ) as? TruBrokerBannerCell else {
            return UICollectionViewCell()
        }
        
        // Data bindings go here if the API starts returning dynamic banner text.
        // Currently handled statically inside TruBrokerBannerCell.awakeFromNib()
        
        return cell
    }
}
