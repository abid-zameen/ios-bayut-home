//
//  HomeTracker.swift
//  Home
//
//  Created by Hammad Shahid on 22/04/2026.
//

import Foundation

// MARK: - Tracker Protocol
protocol HomeTrackerType: AnyObject {
    func track(_ event: HomeTracker.Event)
}

// MARK: - Tracker Implementation
final class HomeTracker: HomeTrackerType {

    private let trackingAdapter: HomeTrackingAdapter

    init(trackingAdapter: HomeTrackingAdapter) {
        self.trackingAdapter = trackingAdapter
    }

    func track(_ event: Event) {
        let params = event.parameters
        trackingAdapter.track(eventName: event.name, parameters: params)
    }
}

// MARK: - Events
extension HomeTracker {

    enum Event {
        case pageView
        case sectionImpression(pageSection: String)
        case blogClick(blogID: Int, title: String, position: Int)
        case blogViewAll
        case popularSearchClick(position: Int, title: String)
        case recentSearchClick(position: Int, title: String)
        case savedSearchClick(position: Int, title: String)
        case favouriteClick(position: Int, externalID: String)
        case nearbyLocationClick(position: Int, locationName: String)
        case bannerClick(pageSection: String, title: String)
        case locationAccess(authorization: String)

        // MARK: - Event Names
        var name: String {
            switch self {
            case .pageView: return "page_view"
            case .sectionImpression: return "section_impression"
            case .blogClick: return "blog_click"
            case .blogViewAll: return "explore_more_articles"
            case .popularSearchClick: return "popular_search_click"
            case .recentSearchClick: return "recent_search_click"
            case .savedSearchClick: return "saved_search_click"
            case .favouriteClick: return "favourite_property_click"
            case .nearbyLocationClick: return "nearby_location_click"
            case .bannerClick: return "banner_click"
            case .locationAccess: return "location_access"
            }
        }

        // MARK: - Parameters
        var parameters: [String: Any] {
            var params: [String: Any] = [
                "website_section": "home",
                "listing_pagetype": "home",
                "item_name": "home"
            ]

            switch self {
            case .pageView:
                break

            case let .sectionImpression(pageSection):
                params["page_section"] = pageSection

            case let .blogClick(blogID, title, position):
                params["page_section"] = "blogs"
                params["item_id"] = String(blogID)
                params["item_name"] = title
                params["position"] = position

            case .blogViewAll:
                params["page_section"] = "blogs"

            case let .popularSearchClick(position, title):
                params["page_section"] = "popular_searches"
                params["position"] = position
                params["item_name"] = title

            case let .recentSearchClick(position, title):
                params["page_section"] = "recent_searches"
                params["position"] = position
                params["item_name"] = title

            case let .savedSearchClick(position, title):
                params["page_section"] = "saved_searches"
                params["position"] = position
                params["item_name"] = title

            case let .favouriteClick(position, externalID):
                params["page_section"] = "favourites"
                params["position"] = position
                params["item_id"] = externalID

            case let .nearbyLocationClick(position, locationName):
                params["page_section"] = "nearby_locations"
                params["position"] = position
                params["item_name"] = locationName

            case let .bannerClick(pageSection, title):
                params["page_section"] = pageSection
                params["item_name"] = title
            case let .locationAccess(authorization):
                params["page_section"] = "location_access"
                params["item_name"] = authorization
            }

            return params
        }
    }
}
