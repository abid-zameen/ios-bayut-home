import UIKit

final class StoriesHostingCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
    
    func configure(with hostedView: UIView, height: CGFloat) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostedView)
        
        let topConstraint = hostedView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottomConstraint = hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .init(250) // Low priority for bottom attachment to avoid stretching
        
        let heightConstraint = hostedView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.priority = .required // Rigid internal height
        
        NSLayoutConstraint.activate([
            topConstraint,
            hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomConstraint,
            heightConstraint
        ])
    }
}
