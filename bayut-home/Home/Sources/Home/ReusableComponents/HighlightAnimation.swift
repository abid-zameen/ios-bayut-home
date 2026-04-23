//
//  HighlightAnimation.swift
//  Home
//
//  Created by Hammad Shahid on 23/04/2026.
//


import Foundation
import UIKit

enum HighlightAnimation {
    case fade
    case scale
    case pulse(subview: UIView?)
}

class HighlightableView: UIView {
    
    // MARK: - Properties
    var highlightScaleX: CGFloat = 0.95
    var highlightScaleY: CGFloat = 0.95
    var highlightAlpha: CGFloat = 0.5
    var highlightAnimation: HighlightAnimation? = .scale
    var highlightAnimationDuration: TimeInterval = 0.2
    private var tapGesture: UILongPressGestureRecognizer!
    var highlightAction: (() -> Void)?
    var unhighlightAction: (() -> Void)?
    var originalBackgroundColor: UIColor?
    var additionalHighlightActions: (() -> Void)?
    var additionalUnhighlightActions: (() -> Void)?
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestureRecognizer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
    }
}

// MARK: - Setup
private extension HighlightableView {
    func setupGestureRecognizer() {
        tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTouch))
        tapGesture.minimumPressDuration = 0
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
}

// MARK: - Gesture handling
private extension HighlightableView {
    @objc
    func handleTouch(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            highlight()
        case .ended, .cancelled:
            unhighlight()
        default:
            break
        }
    }
}

// MARK: - Gesture recognizer delegate
extension HighlightableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UIButton {
            return false
        }
        return true
    }
}

// MARK: - Animation
extension HighlightableView {
    func highlight() {
        guard highlightAction == nil else {
            highlightAction?()
            return
        }
        guard let animation = highlightAnimation else { return }
        switch animation {
        case .fade:
            UIView.animate(withDuration: highlightAnimationDuration) { [weak self] in
                guard let fadeAlpha = self?.highlightAlpha else { return }
                self?.alpha = fadeAlpha
                self?.additionalHighlightActions?()
            }
        case .scale:
            let transform: CGAffineTransform = .init(scaleX: highlightScaleX, y: highlightScaleY)
            UIView.animate(withDuration: highlightAnimationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction],
                           animations: { [weak self] in
                self?.transform = transform
                self?.additionalHighlightActions?()
            }, completion: nil)
        default:
            return
        }
    }
    
    func unhighlight() {
        guard unhighlightAction == nil else {
            unhighlightAction?()
            return
        }
        guard let animation = highlightAnimation else { return }
        switch animation {
        case .fade:
            UIView.animate(withDuration: highlightAnimationDuration) { [weak self] in
                self?.alpha = 1
                self?.additionalUnhighlightActions?()
            }
        case .scale:
            let transform: CGAffineTransform = .identity
            UIView.animate(withDuration: highlightAnimationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction],
                           animations: { [weak self] in
                self?.transform = transform
                self?.additionalUnhighlightActions?()
            }, completion: nil)
        default:
            return
        }
    }
}

