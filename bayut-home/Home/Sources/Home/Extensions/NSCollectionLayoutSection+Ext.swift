//
//  NSCollectionLayoutSection+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 31/03/2026.
//
import UIKit

extension NSCollectionLayoutSection {
    
    /// Creates a standard full-width vertical list section with
    /// optional spacing, and optional header/footer supplementary views.
    ///
    /// - Parameters:
    ///   - estimatedHeight: Estimated height used for self-sizing cells.
    ///   - sectionInsets: Padding applied around the entire section.
    ///   - spacing: Vertical spacing between successive groups.
    ///   - header: Optional configuration for a section header.
    ///   - footer: Optional configuration for a section footer.
    ///
    /// - Returns: A fully configured `NSCollectionLayoutSection`.
    static func fullWidthList(
        estimatedHeight: CGFloat = 10,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        spacing: CGFloat = 0,
        headerSize: NSCollectionLayoutSize? = nil,
        footerSize: NSCollectionLayoutSize? = nil
    ) -> NSCollectionLayoutSection {
        
        // MARK: Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // MARK: Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // MARK: Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionInsets
        section.interGroupSpacing = spacing
        
        // MARK: Boundary Supplementary Items (Header / Footer)
        var boundaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        
        if let headerSize {
            boundaryItems.append(
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            )
        }
        
        if let footerSize {
            boundaryItems.append(
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
            )
        }
        
        section.boundarySupplementaryItems = boundaryItems
        return section
    }

    /// Creates a layout section with self-sizing items that flow horizontally.
    static func horizontalFlow(
        height: CGFloat,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        chipSpacing: CGFloat = 10,
        interGroupSpacing: CGFloat = 10,
        headerSize: NSCollectionLayoutSize? = nil
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(chipSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionInsets
        section.interGroupSpacing = interGroupSpacing
        
        if let headerSize {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
}
