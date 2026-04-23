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
    private let actions: SellerLeadsBannerActions
    
    init(actions: SellerLeadsBannerActions) {
        self.actions = actions
    }
    
    // MARK: - Item
    struct Item: Hashable {
        let id: String = "sellerLeads_banner_unique_id"
    }
    
    func buildItems() -> [Item] {
        [Item()]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return .fullWidthList(
            estimatedHeight: 180,
            sectionInsets: NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 0)
        )
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SellerLeadsBannerCell.reuseId, for: indexPath
        ) as? SellerLeadsBannerCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.sellerLeadsBannerDidTap()
    }
}
