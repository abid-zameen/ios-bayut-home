//
//  HomePresenter.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomePresentationLogic: AnyObject {
    func presentData()
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    // MARK: - HomePresentationLogic
    @MainActor
    func presentData() {
        guard let viewController = viewController as? HomeViewController else { return }
        
        // MARK: Mock Data Layer
        let locations = [
            LocationChipViewModel(name: "Dubai Marina", localizedName: "Dubai Marina", externalID: "1", isSelected: true),
            LocationChipViewModel(name: "Downtown Dubai", localizedName: "Downtown Dubai", externalID: "2", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "4", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "5", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "6", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "7", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "8", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "9", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "10", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "11", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "12", isSelected: false),
            LocationChipViewModel(name: "Palm Jumeirah", localizedName: "Palm Jumeirah", externalID: "13", isSelected: false)
        ]
        
        let projects = [
            NewProject(
                id: "p1",
                title: "Luxury Villa",
                type: "Villa",
                location: "Dubai Marina",
                startingPrice: "AED 2,000,000",
                handoverValue: "Q4 2026",
                imageURL: nil,
                showWhatsappButton: true
            ),
            NewProject(
                id: "p2",
                title: "Modern Apartment",
                type: "Apartment",
                location: "Downtown Dubai",
                startingPrice: "AED 1,500,000",
                handoverValue: "Q2 2025",
                imageURL: nil,
                showWhatsappButton: false
            )
        ]
        
        let favourites = [
            FavouriteProperty(id: "f1", title: "Mag 214 Tower", location: "Jumeirah Lake Towers (JLT)", price: "AED 2,500,000", beds: "2", baths: "2", area: "1,234 sqft", imageURL: nil),
            FavouriteProperty(id: "f2", title: "Marina Heights", location: "Dubai Marina", price: "AED 3,200,000", beds: "3", baths: "3", area: "1,800 sqft", imageURL: nil),
            FavouriteProperty(id: "f3", title: "Burj Khalifa Apartment", location: "Downtown Dubai", price: "AED 15,000,000", beds: "3", baths: "4", area: "2,500 sqft", imageURL: nil)
        ]
        
        let savedSearches = [
            SavedSearchesModel(title: "Apartment for Sale", location: "Dubai Marina", searchName: "Marina Apartments", image: ""),
            SavedSearchesModel(title: "Villa for Rent", location: "Palm Jumeirah", searchName: "Palm Villas", image: ""),
            SavedSearchesModel(title: "Office for Sale", location: "Downtown Dubai", searchName: "Downtown Offices", image: "")
        ]
        
        let blogs = [
            BlogData(title: "Dubai Real Estate Market 2026", category: "Market Profile", image: ""),
            BlogData(title: "Top 5 Areas for Families", category: "Area Guides", image: ""),
            BlogData(title: "Mortgage Guide for Expats", category: "Home Buying", image: "")
        ]
        
        let nearbyLocations = [
            NearbyLocation(name: "Dubai Marina Mall", distance: "0.5 km", city: "Dubai"),
            NearbyLocation(name: "JBR Beach", distance: "1.2 km", city: "Dubai"),
            NearbyLocation(name: "Skydive Dubai", distance: "2.0 km", city: "Dubai")
        ]
        
        let popularSearches = [
            PopularSearch(title: "Apartments", location: "in UAE", iconName: "rent_icon"),
            PopularSearch(title: "Villas", location: "in Dubai", iconName: "buy_icon"),
            PopularSearch(title: "Offices", location: "in Abu Dhabi", iconName: "commercial_icon"),
            PopularSearch(title: "Townhouses", location: "in UAE", iconName: "buy_icon")
        ]
        
        let purposes: [PopularSearchPurpose] = [.buy, .rent]
        
        let sectionsBuilder = HomeSectionBuilder()
        let sections = sectionsBuilder.buildSections(sectionsData: Home.HomeSections(
            projects: projects,
            locations: locations,
            favourites: favourites,
            savedSearches: savedSearches,
            blogs: blogs,
            nearbyLocations: nearbyLocations,
            isLocationEnabled: false,
            popularSearches: popularSearches,
            purposes: purposes,
            selectedPurpose: .rent,
            viewController: viewController)
        )
        
        // MARK: Complete VIP Cycle -> Present view model
        let viewModel = Home.HomeViewModel(sections: sections, animated: false)
        viewController.displaySections(viewModel: viewModel)
    }
}
