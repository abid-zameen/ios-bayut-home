//
//  HomeHeaderAnimatable.swift
//  Home
//
//  Created by Hammad Shahid on 06/04/2026.
//

import UIKit

enum HeaderVariant {
    case aiSearch
    case standard
}

// MARK: - Animatable Element

/// A declarative description of how a single UI element should animate
/// as the header collapses from expanded (progress=0) to sticky (progress=1).
///
/// Usage: Create one per animated view, then let the `HeaderAnimationEngine`
/// drive all of them from a single `progress` value.
///
struct AnimatableElement {
    weak var view: UIView?
    var topConstraint: NSLayoutConstraint?
    var expandedTop: CGFloat
    var collapsedTop: CGFloat
    
    /// An optional second constraint to animate independently (e.g. height, leading).
    var secondaryConstraint: NSLayoutConstraint?
    var expandedSecondary: CGFloat = 0
    var collapsedSecondary: CGFloat = 0
    var expandedAlpha: CGFloat = 1.0
    var collapsedAlpha: CGFloat = 1.0
    var alphaStartProgress: CGFloat = 0.0
    var alphaEndProgress: CGFloat = 1.0
    var constraintEndProgress: CGFloat = 1.0
    var hideThreshold: CGFloat? = nil
    var activeVariants: Set<HeaderVariant>? = nil
}

extension HeaderVariant: Hashable {}
final class HeaderAnimationEngine {

    var elements: [AnimatableElement] = []
    var currentVariant: HeaderVariant = .aiSearch

    /// Applies animation state to all registered elements for the given progress.
    /// - Parameter progress: A value in the range [0.0, 1.0] where 0 = expanded, 1 = collapsed.
    func apply(progress: CGFloat) {
        for var element in elements {
            // Skip and hide elements not active for the current variant
            if let activeVariants = element.activeVariants, !activeVariants.contains(currentVariant) {
                element.view?.isHidden = true
                element.view?.alpha = 0
                continue
            }
            
            if let constraint = element.topConstraint {
                let cp = element.constraintEndProgress > 0
                    ? min(1, max(0, progress / element.constraintEndProgress))
                    : progress
                constraint.constant = lerp(from: element.expandedTop, to: element.collapsedTop, progress: cp)
            }

            if let constraint = element.secondaryConstraint {
                let cp = element.constraintEndProgress > 0
                    ? min(1, max(0, progress / element.constraintEndProgress))
                    : progress
                constraint.constant = lerp(from: element.expandedSecondary, to: element.collapsedSecondary, progress: cp)
            }

            let alphaRange = element.alphaEndProgress - element.alphaStartProgress
            if alphaRange > 0 {
                let localProgress = min(1, max(0, (progress - element.alphaStartProgress) / alphaRange))
                element.view?.alpha = lerp(from: element.expandedAlpha, to: element.collapsedAlpha, progress: localProgress)
            }


            if let threshold = element.hideThreshold {
                element.view?.isHidden = progress > threshold
            }
        }
    }

    // MARK: - Private Helpers

    private func lerp(from start: CGFloat, to end: CGFloat, progress: CGFloat) -> CGFloat {
        return start + (end - start) * progress
    }
}
