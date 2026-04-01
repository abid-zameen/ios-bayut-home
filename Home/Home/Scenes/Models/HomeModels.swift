//
//  HomeModels.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

struct Home {
    struct HomeViewModel {
        let sections: [AnySection]
        let animated: Bool
    }
    
    struct HomeSections {
        let projects: [NewProject]
        let locations: [LocationChipViewModel]
        let viewController: HomeViewController
    }
}
