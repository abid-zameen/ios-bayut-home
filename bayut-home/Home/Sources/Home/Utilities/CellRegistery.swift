//
//  CellRegistry.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import UIKit

final class CellRegistry {
    static func registerCells(in collectionView: UICollectionView) {
        
        // Programmatic Cells
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.reuseId)
        collectionView.register(ViewMoreCell.self, forCellWithReuseIdentifier: ViewMoreCell.reuseId)
        
        // NIB-based Cells
        let locationNib = UINib(nibName: LocationChipsCollectionViewCell.reuseId, bundle: .module)
        collectionView.register(locationNib, forCellWithReuseIdentifier: LocationChipsCollectionViewCell.reuseId)
        
        let projectNib = UINib(nibName: ProjectsCollectionViewCell.reuseId, bundle: .module)
        collectionView.register(projectNib, forCellWithReuseIdentifier: ProjectsCollectionViewCell.reuseId)
        
        // TruBroker Banner
        let truBrokerNib = UINib(nibName: TruBrokerBannerCell.reuseId, bundle: .module)
        collectionView.register(truBrokerNib, forCellWithReuseIdentifier: TruBrokerBannerCell.reuseId)
        
        // Seller Leads Banner
        let sellerLeadsNib = UINib(nibName: SellerLeadsBannerCell.reuseId, bundle: .module)
        collectionView.register(sellerLeadsNib, forCellWithReuseIdentifier: SellerLeadsBannerCell.reuseId)
        
        // Railing Section
        let railingCardNib = UINib(nibName: RailingCardCell.reuseId, bundle: .module)
        collectionView.register(railingCardNib, forCellWithReuseIdentifier: RailingCardCell.reuseId)
        collectionView.register(PageControlCell.self, forCellWithReuseIdentifier: PageControlCell.reuseId)
        
        // Favourites Section
        let favouritesNib = UINib(nibName: FavouritesCell.reuseId, bundle: .module)
        collectionView.register(favouritesNib, forCellWithReuseIdentifier: FavouritesCell.reuseId)
        
        // Saved Searches Section
        let savedSearchesNib = UINib(nibName: SavedSearchesCell.reuseId, bundle: .module)
        collectionView.register(savedSearchesNib, forCellWithReuseIdentifier: SavedSearchesCell.reuseId)
        
        // Blogs Section
        let blogNib = UINib(nibName: BlogCell.reuseId, bundle: .module)
        collectionView.register(blogNib, forCellWithReuseIdentifier: BlogCell.reuseId)
        
        // Nearby Locations Section
        let nearbyNib = UINib(nibName: NearbyLocationCell.reuseId, bundle: .module)
        collectionView.register(nearbyNib, forCellWithReuseIdentifier: NearbyLocationCell.reuseId)
        
        let mapNib = UINib(nibName: MapCell.reuseId, bundle: .module)
        collectionView.register(mapNib, forCellWithReuseIdentifier: MapCell.reuseId)
        
        // Popular Search Section
        collectionView.register(UINib(nibName: "PopularSearchPurposeCell", bundle: .module), forCellWithReuseIdentifier: "PopularSearchPurposeCell")
        collectionView.register(UINib(nibName: "PopularSearchCell", bundle: .module), forCellWithReuseIdentifier: "PopularSearchCell")
        
        let recentSearchesCellNib = UINib(nibName: RecentSearchesViewCell.reuseId, bundle: .module)
        collectionView.register(recentSearchesCellNib, forCellWithReuseIdentifier: RecentSearchesViewCell.reuseId)
        
        // Stories Hosting Cell
        collectionView.register(StoriesHostingCell.self, forCellWithReuseIdentifier: StoriesHostingCell.reuseId)
        
        // Add more cells to register here
    }
}
