import UIKit

final class HomeHeaderTabsView: UIView {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(TabCell.self, forCellWithReuseIdentifier: TabCell.reuseId)
        return cv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        return view
    }()
    
    // MARK: - Properties
    private var tabs: [HomeHeaderTab] = []
    private var selectedIndex: Int = 0
    var onTabSelected: ((HomeHeaderTab) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
    }
    
    func setupTabs(tabs: [HomeHeaderTab]) {
        self.tabs = tabs
        self.selectedIndex = 0
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension HomeHeaderTabsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.reuseId, for: indexPath) as? TabCell else {
            return UICollectionViewCell()
        }
        let tab = tabs[indexPath.item]
        cell.configure(title: tab.title, isSelected: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndex != indexPath.item else { return }
        selectedIndex = indexPath.item
        collectionView.reloadData()
        onTabSelected?(tabs[selectedIndex])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = tabs[indexPath.item].title
        let font = UIFont.headingL4
        let width = title.size(withAttributes: [.font: font]).width + 32

        if tabs.count <= 2 {
            let totalAvailableWidth = max(0.1, collectionView.bounds.width - 4)
            return CGSize(width: totalAvailableWidth / CGFloat(tabs.count), height: 28)
        }
        
        return CGSize(width: width, height: 28)
    }
}
