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
    private let actions: TruBrokerBannerActions
    
    init(actions: TruBrokerBannerActions) {
        self.actions = actions
    }
    
    // MARK: - Item
    struct Item: Hashable {
        let id: String = "truBroker_banner_unique_id"
    }
    
    // MARK: - Build Items
    func buildItems() -> [Item] {
        [Item()]
    }
    
    // MARK: - Layout Configuration
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return .fullWidthList(
            estimatedHeight: 100,
            sectionInsets: NSDirectionalEdgeInsets(top: .sectionTopSpace, leading: 16, bottom: 0, trailing: 16)
        )
    }
    
    // MARK: - Cell Rendering
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TruBrokerBannerCell.reuseId, for: indexPath
        ) as? TruBrokerBannerCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {
        actions.delegate?.truBrokerBannerDidTap()
    }
}
