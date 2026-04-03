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
        let locationNib = UINib(nibName: LocationChipsCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(locationNib, forCellWithReuseIdentifier: LocationChipsCollectionViewCell.reuseId)
        
        let projectNib = UINib(nibName: ProjectsCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(projectNib, forCellWithReuseIdentifier: ProjectsCollectionViewCell.reuseId)
        
        // TruBroker Banner
        let truBrokerNib = UINib(nibName: TruBrokerBannerCell.reuseId, bundle: nil)
        collectionView.register(truBrokerNib, forCellWithReuseIdentifier: TruBrokerBannerCell.reuseId)
        
        // Seller Leads Banner
        let sellerLeadsNib = UINib(nibName: SellerLeadsBannerCell.reuseId, bundle: nil)
        collectionView.register(sellerLeadsNib, forCellWithReuseIdentifier: SellerLeadsBannerCell.reuseId)
        
        // Railing Section
        let railingCardNib = UINib(nibName: RailingCardCell.reuseId, bundle: nil)
        collectionView.register(railingCardNib, forCellWithReuseIdentifier: RailingCardCell.reuseId)
        collectionView.register(PageControlCell.self, forCellWithReuseIdentifier: PageControlCell.reuseId)
        
        // Favourites Section
        let favouritesNib = UINib(nibName: FavouritesCell.reuseId, bundle: nil)
        collectionView.register(favouritesNib, forCellWithReuseIdentifier: FavouritesCell.reuseId)
        
        // Saved Searches Section
        let savedSearchesNib = UINib(nibName: SavedSearchesCell.reuseId, bundle: nil)
        collectionView.register(savedSearchesNib, forCellWithReuseIdentifier: SavedSearchesCell.reuseId)
        
        // Blogs Section
        let blogNib = UINib(nibName: BlogCell.reuseId, bundle: nil)
        collectionView.register(blogNib, forCellWithReuseIdentifier: BlogCell.reuseId)
        
        // Nearby Locations Section
        let nearbyNib = UINib(nibName: NearbyLocationCell.reuseId, bundle: nil)
        collectionView.register(nearbyNib, forCellWithReuseIdentifier: NearbyLocationCell.reuseId)
        
        let mapNib = UINib(nibName: MapCell.reuseId, bundle: nil)
        collectionView.register(mapNib, forCellWithReuseIdentifier: MapCell.reuseId)
        
        // Popular Search Section
        collectionView.register(UINib(nibName: "PopularSearchPurposeCell", bundle: nil), forCellWithReuseIdentifier: "PopularSearchPurposeCell")
        collectionView.register(UINib(nibName: "PopularSearchCell", bundle: nil), forCellWithReuseIdentifier: "PopularSearchCell")
        
        // Add more cells to register here
    }
}
