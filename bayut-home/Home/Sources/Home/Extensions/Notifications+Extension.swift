//
//  Notification+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 09/04/2026.
//
import Foundation

public extension Notification.Name {
    static let homeRefreshUserSpecificData = Notification.Name("HomeRefreshUserSpecificData")
    static let loggedIn = Notification.Name("loggedIn")
    static let loggedOut = Notification.Name("loggedOut")
    static let refreshRecentSeachesOnHome = Notification.Name("refreshRecentSeachesOnHome")
    static let refreshPopularSearchesOnHome = Notification.Name("refreshPopularSearchesOnHome")
}
