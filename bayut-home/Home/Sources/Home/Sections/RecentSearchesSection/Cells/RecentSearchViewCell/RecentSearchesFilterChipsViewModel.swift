//
//  RecentSearchesFilterChipsViewModel.swift
//  Home
//
//  Created by Hammad Shahid on 13/04/2026.
//

import UIKit

struct FilterChipsPresentation {
    let first: String?
    let second: String?
    let plusText: String?
}

struct RecentSearchesFilterChipsViewModel {
    let filters: [HomeScreenRecentSearchFilter]
    let maxChipsWidth: CGFloat = 214
    let spacing: CGFloat = 4
    let font: UIFont = UIFont.body0
    
    func present() -> FilterChipsPresentation {
        guard !filters.isEmpty else {
            return .init(first: nil, second: nil, plusText: nil)
        }
        
        let sorted = filters.sorted { $0.type.priority < $1.type.priority }
        let totalFilters = sorted.count
        
        let chips = sorted.map { $0.value }
        
        if totalFilters == 1 {
            return .init(first: chips.first, second: nil, plusText: nil)
        }
        
        if totalFilters == 2 {
            let first = chips[0]
            let second = chips[1]
            let firstWidth = chipWidth(first)
            let secondWidth = chipWidth(second)
            
            if (firstWidth + spacing + secondWidth) <= maxChipsWidth {
                return .init(first: first, second: second, plusText: nil)
            } else if (firstWidth + spacing + plusWidth(for: 1)) <= maxChipsWidth {
                return .init(first: first, second: nil, plusText: "+1")
            } else {
                return .init(first: nil, second: nil, plusText: "+2")
            }
        }
        
        let first = chips[0]
        let firstWidth = chipWidth(first)
        let plusTerm = "+\(totalFilters - 1)"
        
        if (firstWidth + spacing + chipWidth(plusTerm)) <= maxChipsWidth {
            let second = chips[1]
            let secondWidth = chipWidth(second)
            let plusTerm2 = "+\(totalFilters - 2)"
            if (firstWidth + spacing + secondWidth + spacing + chipWidth(plusTerm2)) <= maxChipsWidth {
                return .init(first: first, second: second, plusText: plusTerm2)
            }
            return .init(first: first, second: nil, plusText: plusTerm)
        }
        
        return .init(first: nil, second: nil, plusText: "+\(totalFilters)")
    }
    
    private func chipWidth(_ text: String) -> CGFloat {
        let size = (text as NSString).size(withAttributes: [.font: font])
        return size.width + 16
    }
    
    private func plusWidth(for count: Int) -> CGFloat {
        let text = "+\(count)"
        return chipWidth(text)
    }
}
