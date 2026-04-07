//
//  SellerLeadsBannerSection.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

// MARK: - Identifier
enum SellerLeadsBannerSectionId: String, SectionIdentifier {
    case main = "sellerLeadsBanner"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Section Descriptor
final class SellerLeadsBannerSection: SectionDescriptor {
    typealias Identifier = SellerLeadsBannerSectionId
    
    let identifier: SellerLeadsBannerSectionId = .main
    
    // MARK: - Item
    struct Item: Hashable {
        let id: String = "sellerLeads_banner_unique_id" // Static identity per banner
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
            estimatedHeight: 180, // Estimated starting height for self-sizing wrapper
            sectionInsets: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        )
    }
    
    // MARK: - Cell Rendering
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SellerLeadsBannerCell.reuseId, for: indexPath
        ) as? SellerLeadsBannerCell else {
            return UICollectionViewCell()
        }
        
        // Data bindings go here if the API starts returning dynamic banner text.
        // Currently handled statically inside SellerLeadsBannerCell.awakeFromNib()
        
        return cell
    }
}
