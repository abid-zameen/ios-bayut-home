//
//  HomeTrackingAdapter.swift
//  Home
//
//  Created by Hammad Shahid on 22/04/2026.
//

public protocol HomeTrackingAdapter: AnyObject {
    func track(eventName: String, parameters: [String: Any])
}
