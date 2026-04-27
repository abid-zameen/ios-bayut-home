//
//  Date+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//
import Foundation

extension Date {
    var quarter: Int {
        return (Calendar.current.component(.month, from: self) - 1) / 3 + 1
    }
    
    var yearInt: Int {
        return Calendar.current.component(.year, from: self)
    }
}
