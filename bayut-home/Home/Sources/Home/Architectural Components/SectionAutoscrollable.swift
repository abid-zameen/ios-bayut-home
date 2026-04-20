import UIKit

/// Defines a generic mechanism for sections that support automatic scrolling (carousels/banners).
public protocol SectionAutoscrollable: AnyObject {
    /// The time interval between automatic scrolls.
    var autoscrollInterval: TimeInterval { get }
    
    /// Signal from the section when user interaction starts (to pause timers).
    var onInteractionBegan: (() -> Void)? { get set }
    
    /// Request from the parent to scroll to the next logical item.
    func scrollToNext(in collectionView: UICollectionView, at sectionIndex: Int)
    
    /// Request from the parent to scroll to a specific logical page.
    func scrollToPage(_ page: Int, in collectionView: UICollectionView, at sectionIndex: Int)
    
    /// Request from the parent to ensure the section is centered (e.g. for infinite loops).
    func centerIfNeeded(in collectionView: UICollectionView, at sectionIndex: Int)
}
