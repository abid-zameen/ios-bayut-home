import UIKit

enum StoriesSectionId: String, SectionIdentifier {
    case main = "stories.main"
    
    var displayName: String? { nil }
    var section: HomeSection? { .main }
}

final class StoriesSection: SectionDescriptor {
    typealias Identifier = StoriesSectionId
    let identifier: StoriesSectionId = .main
    
    struct Item: Hashable {
        let id = "stories.mian.item"
    }
    
    private let hostedView: UIView
    private let viewHeight: CGFloat
    
    init(hostedView: UIView, viewHeight: CGFloat) {
        self.hostedView = hostedView
        self.viewHeight = viewHeight
    }
    
    func buildItems() -> [Item] {
        return [Item()]
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(viewHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(viewHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: .sectionTopSpace, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesHostingCell.reuseId, for: indexPath) as? StoriesHostingCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hostedView, height: viewHeight)
        return cell
    }
}
