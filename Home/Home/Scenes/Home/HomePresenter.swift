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
        
        let sectionsBuilder = HomeSectionBuilder()
        let sections = sectionsBuilder.buildSections(sectionsData: Home.HomeSections (
            projects: projects,
            locations: locations,
            viewController: viewController)
        )
        
        // MARK: Complete VIP Cycle -> Present view model
        let viewModel = Home.HomeViewModel(sections: sections, animated: false)
        viewController.displaySections(viewModel: viewModel)
    }
}
