//
//  SectionDescriptor.swift
//  TruEstimate
//
//  Created by Muhammad Hammad on 24/12/2025.
//

import UIKit

/// Stable identifier for sections – used for tabs, scrolling, customization and reordering.
///
/// Usage guidelines (for consistency across the report):
/// - Use an **enum** conforming to `SectionIdentifier` for single-use sections with a fixed identity,
///   for example `enum TruEstimateSectionId: String, SectionIdentifier { case main = "truEstimate" }`.
/// - Use a **struct** conforming to `SectionIdentifier` only when a section type must be reused
///   with different identities at runtime
protocol SectionIdentifier: Hashable {
    var rawValue: String { get }
    var displayName: String? { get }
    var section: HomeSection?{ get }
}

/// A self-contained section that knows how to build its own layout, cells, and items
///
/// **Responsibilities:**
/// - Transform DTOs into cell ViewModels (in `buildItems()`)
/// - Define section layout (in `layoutSection()`)
/// - Configure cells (in `configureCell()`)
/// - Optionally provide supplementary views (headers/footers)
///
/// **Pattern:**
/// - Sections receive DTOs/data in their initializer
/// - Sections create ViewModels internally in `buildItems()`
/// - Each section owns its transformation logic
protocol SectionDescriptor {
    associatedtype Item: Hashable
    associatedtype Identifier: SectionIdentifier
    
    /// Stable identifier for this section (used for tabs, scrolling, drag-drop)
    var identifier: Identifier { get }
    
    func buildItems() -> [Item]
    var isShimmering: Bool { get }
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath, with item: Item) -> UICollectionViewCell
    func configureSupplementaryView(in collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView?
    func didSelectItem(at indexPath: IndexPath, with item: Item)
}

extension SectionDescriptor {
    func configureSupplementaryView(in collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
    
    var isShimmering: Bool { false }
    
    func didSelectItem(at indexPath: IndexPath, with item: Item) {}
}
