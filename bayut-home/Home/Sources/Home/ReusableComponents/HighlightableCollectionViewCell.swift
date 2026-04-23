//
//  HighlightableCollectionViewCell.swift
//  Home
//
//  Created by Hammad Shahid on 23/04/2026.
//
import UIKit

class HighlightableCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var highlightScaleX: CGFloat = 0.95
    var highlightScaleY: CGFloat = 0.95
    var hightlightAlpha: CGFloat = 0.5
    var hightlightAnimation: HighlightAnimation? = .scale
    var highlightAnimationDuration: TimeInterval = 0.2
    private var tapGesture: UILongPressGestureRecognizer!
    var highlightAction: (() -> Void)?
    var unHighlightAction: (() -> Void)?
    var alongSideHighlightAction: (() -> Void)?
    var alongSideUnhighlightAction: (() -> Void)?
    var originalBackgroundColor: UIColor?
    var pulseHighlightedColor: UIColor = UIColor.AppColors.grey1
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updatePulseHighLightedColorForGreen(){
        pulseHighlightedColor = UIColor.AppColors.green2.withAlphaComponent(0.7)
    }
    
    func resetPulseHighlightedColor(){
         pulseHighlightedColor = UIColor.AppColors.grey1
    }
    
    func updatePulseHighligtedColorForGrey(){
        pulseHighlightedColor = UIColor.AppColors.grey2.withAlphaComponent(0.8)
    }
    
    func set(highlightedColorForPulseAnimation: UIColor){
        pulseHighlightedColor = highlightedColorForPulseAnimation
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                highlight()
            } else {
                unhighlight()
            }
        }
    }
}

// MARK: - Setup
private extension HighlightableCollectionViewCell {
    private func setupGestureRecognizer() {
        tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTouch))
        tapGesture.minimumPressDuration = 0
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        contentView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Gesture handling
private extension HighlightableCollectionViewCell {
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
extension HighlightableCollectionViewCell: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UIButton {
            return false
        }
        return gestureRecognizer.view == contentView
    }
}

// MARK: - Animation
extension HighlightableCollectionViewCell {
    func highlight() {
        guard highlightAction == nil else {
            highlightAction?()
            return
        }
        guard let animation = self.hightlightAnimation else { return }
        switch animation {
        case .fade:
            UIView.animate(withDuration: highlightAnimationDuration) { [weak self] in
                guard let fadeAlpha = self?.hightlightAlpha else { return }
                self?.alpha = fadeAlpha
                self?.alongSideHighlightAction?()
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
                self?.alongSideHighlightAction?()
            }, completion: nil)
        case .pulse(let subView):
            if let subView {
                originalBackgroundColor = subView.backgroundColor
                subView.backgroundColor = pulseHighlightedColor
            } else {
                originalBackgroundColor = backgroundColor
                backgroundColor = pulseHighlightedColor
            }
        }
    }
    
    func unhighlight() {
        guard unHighlightAction == nil else {
            unHighlightAction?()
            return
        }
        guard let animation = self.hightlightAnimation else { return }
        switch animation {
        case .fade:
            UIView.animate(withDuration: highlightAnimationDuration) { [weak self] in
                self?.alpha = 1
                self?.alongSideUnhighlightAction?()
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
                self?.alongSideUnhighlightAction?()
            }, completion: nil)
        case .pulse(let subView):
            if let originalBackgroundColor {
                if let subView {
                    subView.backgroundColor = originalBackgroundColor
                } else {
                    backgroundColor = originalBackgroundColor
                }
            }
        }
    }
}
