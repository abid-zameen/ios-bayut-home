import UIKit

// MARK: - Identifier
enum MarketingBannerSectionId: String, SectionIdentifier {
    case main = "marketingBanner"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

// MARK: - Section Descriptor
final class MarketingBannerSection: SectionDescriptor {
    typealias Identifier = MarketingBannerSectionId
    
    let identifier: MarketingBannerSectionId = .main
    private let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    // MARK: - Item
    struct Item: Hashable {
        let id: String = "marketing_banner_unique_id"
        let imageUrl: String
    }
    
    func buildItems() -> [Item] {
        [Item(imageUrl: imageUrl)]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarketingBannerCell.reuseId, for: indexPath
        ) as? MarketingBannerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: item.imageUrl)
        return cell
    }
}
