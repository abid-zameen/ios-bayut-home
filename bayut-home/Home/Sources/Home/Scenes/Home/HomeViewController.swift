import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displaySections(viewModel: Home.HomeViewModel)
}

final class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    
    // MARK: - UI Components
    private lazy var homeHeaderView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.variant = variant
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Private Properties
    private var dataSource: UICollectionViewDiffableDataSource<AnySection, AnyHashable>!
    private var headerTopConstraint: NSLayoutConstraint?
    private var headerHeightConstraint: NSLayoutConstraint?
    private var initialHeaderHeight: CGFloat = 350
    private var isInitialInsetSet = false
    private var variant: HeaderVariant = .uae
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureDataSource()
        CellRegistry.registerCells(in: collectionView)
    }
    
    func loadData() {
        Task {
            await interactor?.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupInitialInsetIfNeeded()
    }
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(homeHeaderView)
        collectionView.bounces = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerTopConstraint = homeHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        headerHeightConstraint = homeHeaderView.heightAnchor.constraint(equalToConstant: initialHeaderHeight)
        headerHeightConstraint?.priority = .defaultLow
        NSLayoutConstraint.activate([
            headerTopConstraint!,
            homeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerHeightConstraint!
        ])
    }
    
    private func setupInitialInsetIfNeeded() {
        guard !isInitialInsetSet else { return }
        
        homeHeaderView.update(progress: 0)
        homeHeaderView.layoutIfNeeded()
        
        let frameHeight = homeHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        guard frameHeight > 0 else { return }
        
        let visualBottom = homeHeaderView.visibleContentBottom
        initialHeaderHeight = visualBottom + 12
        headerHeightConstraint?.constant = visualBottom
        headerHeightConstraint?.priority = .required
        
        let bottomGap: CGFloat = 8
        let totalInset = visualBottom + bottomGap
        collectionView.contentInset = UIEdgeInsets(top: totalInset, left: 0, bottom: 0, right: 0)
        collectionView.contentOffset = CGPoint(x: 0, y: -totalInset)
        
        isInitialInsetSet = true
    }
    
    // MARK: - Display Logic
    func displaySections(viewModel: Home.HomeViewModel) {
        applySnapshot(sections: viewModel.sections, animated: viewModel.animated)
    }
}


// MARK: - UICollectionViewDelegate (Scroll Logic)
extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let stickyHeight: CGFloat = 140
        let bottomGap = scrollView.contentInset.top - initialHeaderHeight
        let maxCollapseOffset = initialHeaderHeight - stickyHeight
        
        let absoluteOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        let adjustedOffset = max(0, absoluteOffset - bottomGap)
        let progress = min(1, max(0, adjustedOffset / maxCollapseOffset))
        
        homeHeaderView.update(progress: progress)
        headerHeightConstraint?.constant = initialHeaderHeight - (initialHeaderHeight - stickyHeight) * progress
    }
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let stickyHeight: CGFloat = 140
        let bottomGap = scrollView.contentInset.top - initialHeaderHeight
        let maxCollapseOffset = initialHeaderHeight - stickyHeight
        let totalInset = scrollView.contentInset.top
        
        let absoluteTarget = targetContentOffset.pointee.y + totalInset
        let adjustedTarget = max(0, absoluteTarget - bottomGap)
        
        // Only snap if we're mid-collapse
        if adjustedTarget > 0 && adjustedTarget < maxCollapseOffset {
            if adjustedTarget < maxCollapseOffset / 2 {
                // Snap to EXPANDED: scroll back to natural rest
                targetContentOffset.pointee.y = -totalInset
            } else {
                // Snap to COLLAPSED: jump to fully collapsed position
                targetContentOffset.pointee.y = -totalInset + bottomGap + maxCollapseOffset
            }
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        section.didSelectItem(at: indexPath, with: item)
    }
}

// MARK: - Section Handlers
extension HomeViewController: NewProjectsActionsDelegate {
    func newProjectsDidTapCard(at index: Int) { }
    func newProjectsDidTapLocationChip(externalID: String) { }
    func newProjectsDidTapViewAll() { }
}
    
extension HomeViewController: RailingActionsDelegate {
    func railingDidTapCard(at index: Int) { }
    func railingDidTapPageControl(index: Int) { }
}

extension HomeViewController: FavouritesActionsDelegate {
    func favouritesDidTapCard(at index: Int) { }
    func favouritesDidTapViewAll() { }
}

extension HomeViewController: SavedSearchesActionsDelegate {
    func savedSearchesDidTapCard(at index: Int) { }
    func savedSearchesDidTapViewAll() { }
}

extension HomeViewController: BlogsActionsDelegate {
    func blogsDidTapCard(at index: Int) { }
    func blogsDidTapViewAll() { }
}

extension HomeViewController: NearbyLocationsActionsDelegate {
    func nearbyLocationsDidTapCard(at index: Int) {
        // Handle card tap - navigate to area detail if needed
    }
    
    func nearbyLocationsDidTapAllowLocation() {
        interactor?.requestLocationAuthorization()
    }
}

extension HomeViewController: PopularSearchActionsDelegate {
    func popularSearchDidSelectPurpose(_ purpose: PopularSearchPurpose) { }
    func popularSearchDidSelectSearchItem(at index: Int) { }
}

// MARK: - Layout & Data Source
private extension HomeViewController {
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return .fullWidthList() }
            let snapshot = self.dataSource.snapshot()
            guard sectionIndex < snapshot.numberOfSections else { return .fullWidthList() }
            let section = snapshot.sectionIdentifiers[sectionIndex]
            return section.layoutSection(environment: environment)
        }
        layout.register(BorderedSectionBackgroundView.self, forDecorationViewOfKind: BorderedSectionBackgroundView.reuseId)
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AnySection, AnyHashable>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            return section.configureCell(in: collectionView, at: indexPath, with: item)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            return section.configureSupplementaryView(in: collectionView, kind: kind, at: indexPath) ?? UICollectionReusableView()
        }
    }
    
    func applySnapshot(sections: [AnySection], animated: Bool) {
        var newSnapshot = NSDiffableDataSourceSnapshot<AnySection, AnyHashable>()
        newSnapshot.appendSections(sections)
        for section in sections {
            let items = section.buildItems()
            if !items.isEmpty {
                newSnapshot.appendItems(items, toSection: section)
            }
        }
        dataSource.apply(newSnapshot, animatingDifferences: animated)
    }
}
