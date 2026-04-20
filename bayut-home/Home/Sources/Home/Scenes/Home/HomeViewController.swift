import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displaySections(viewModel: Home.HomeViewModel)
    func displaySavedSearchRouting(savedSearchData: [String: Any], resolvedLocations: [LocationHit])
    func displayRecentSearchRouting(search: HomeScreenRecentSearch)
}

final class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: HomeRoutingLogic?
    
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
    private var variant: HeaderVariant = .gcc
    private var autoscrollTimers: [AnySection: Timer] = [:]
    private var resumeAutoscrollWorkItems: [AnySection: DispatchWorkItem] = [:]
    private let autoscrollResumeDelay: TimeInterval = 2.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureDataSource()
        CellRegistry.registerCells(in: collectionView)
        setupHeaderCallbacks()
        self.loadData()
    }
    
    private func setupHeaderCallbacks() {
        homeHeaderView.onSearchTapped = { [weak self] tab, purpose in
            switch tab {
            case .properties:
                self?.router?.routeToLocationSearch(purpose: purpose)
            case .newProjects:
                self?.router?.routeToLocationForProjects()
            case .transactions:
                self?.router?.routeToLocationForTransactions(purpose: purpose)
            case .agents:
                self?.router?.routeToFindAgents()
            default:
                break
            }
        }
        
        homeHeaderView.onHeaderHeightChanged = { [weak self] in
            self?.recalculateHeaderInsets()
        }
    }
    
    func loadData() {
        Task {
            await interactor?.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        let contentHeight = homeHeaderView.expandedContentHeight
        guard contentHeight > 0 else { return }
        
        initialHeaderHeight = contentHeight + 12
        headerHeightConstraint?.constant = initialHeaderHeight
        headerHeightConstraint?.priority = .required
        
        let bottomGap: CGFloat = 8
        let totalInset = initialHeaderHeight + bottomGap
        collectionView.contentInset = UIEdgeInsets(top: totalInset, left: 0, bottom: 0, right: 0)
        collectionView.contentOffset = CGPoint(x: 0, y: -totalInset)
        
        isInitialInsetSet = true
    }
    
    private func recalculateHeaderInsets() {
        let contentHeight = homeHeaderView.expandedContentHeight
        let newHeight = contentHeight + 12
        initialHeaderHeight = newHeight
        headerHeightConstraint?.constant = newHeight
        
        let bottomGap: CGFloat = 8
        let totalInset = newHeight + bottomGap
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            collectionView.contentInset = UIEdgeInsets(top: totalInset, left: 0, bottom: 0, right: 0)
            collectionView.contentOffset = CGPoint(x: 0, y: -totalInset)
            view.layoutIfNeeded()
        }
        
        homeHeaderView.update(progress: 0)
    }
    
    // MARK: - Display Logic
    func displaySections(viewModel: Home.HomeViewModel) {
        applySnapshot(sections: viewModel.sections, animated: viewModel.animated)
        setupAutoscrolling(for: viewModel.sections)
    }
    
    func displaySavedSearchRouting(savedSearchData: [String: Any], resolvedLocations: [LocationHit]) {
        router?.routeToSavedSearch(savedSearchData: savedSearchData, resolvedLocations: resolvedLocations)
    }
    
    func displayRecentSearchRouting(search: HomeScreenRecentSearch) {
        router?.routeToRecentSearch(recentSearch: search)
    }

    private func setupAutoscrolling(for sections: [AnySection]) {
        stopAllAutoscrolling()
        
        for section in sections {
            guard let autoscrollable = section.autoscrollable else { continue }
            
            let latestSnapshot = dataSource.snapshot()
            if let index = latestSnapshot.indexOfSection(section) {
                autoscrollable.centerIfNeeded(in: collectionView, at: index)
            }
            
            autoscrollable.onInteractionBegan = { [weak self, section] in
                guard let self = self else { return }
                self.pauseAutoscrolling(for: section)
            }
            
            startAutoscrolling(for: autoscrollable, in: section)
        }
    }

    private func startAutoscrolling(for autoscrollable: SectionAutoscrollable, in section: AnySection) {
        autoscrollTimers[section]?.invalidate()
        
        let timer = Timer(timeInterval: autoscrollable.autoscrollInterval, repeats: true) { [weak self, weak autoscrollable, section] _ in
            guard let self = self, let autoscrollable = autoscrollable else { return }
            
            let snapshot = self.dataSource.snapshot()
            guard let index = snapshot.indexOfSection(section) else { return }
            
            autoscrollable.scrollToNext(in: self.collectionView, at: index)
        }
        autoscrollTimers[section] = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func pauseAutoscrolling(for section: AnySection) {
        autoscrollTimers[section]?.invalidate()
        autoscrollTimers[section] = nil
        
        resumeAutoscrollWorkItems[section]?.cancel()
        let task = DispatchWorkItem { [weak self, section] in
            guard let self = self else { return }
            
            let snapshot = self.dataSource.snapshot()
            guard snapshot.sectionIdentifiers.contains(section),
                  let autoscrollable = section.autoscrollable else { return }
            
            self.startAutoscrolling(for: autoscrollable, in: section)
        }
        resumeAutoscrollWorkItems[section] = task
        DispatchQueue.main.asyncAfter(deadline: .now() + autoscrollResumeDelay, execute: task)
    }
    
    private func stopAllAutoscrolling() {
        autoscrollTimers.values.forEach { $0.invalidate() }
        autoscrollTimers.removeAll()
        resumeAutoscrollWorkItems.values.forEach { $0.cancel() }
        resumeAutoscrollWorkItems.removeAll()
    }

}

// MARK: - UICollectionViewDelegate (Scroll Logic)
extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking || scrollView.isDragging {
            stopAllAutoscrolling()
        }

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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let snapshot = dataSource.snapshot()
            setupAutoscrolling(for: snapshot.sectionIdentifiers)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let snapshot = dataSource.snapshot()
        setupAutoscrolling(for: snapshot.sectionIdentifiers)
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
    func newProjectsDidTapCard(hit: ProjectHit) {
        router?.routeToProjectDetail(hit: hit)
    }
    
    func newProjectsDidTapLocationChip(externalID: String) {
        Task {
            await interactor?.didSelectNewProjectsLocation(id: externalID)
        }
    }
    
    func newProjectsDidTapViewAll(externalID: String, displayName: String) {
        router?.routeToProjectsScreen(externalID: externalID, displayName: displayName)
    }
}
    
extension HomeViewController: RailingActionsDelegate {
    func railingDidTapCard(type: RailingCellType) {
        router?.routeToRailing(type: type)
    }
    
    func railingDidTapPageControl(index: Int) {
        let snapshot = dataSource.snapshot()
        guard let sectionIndex = snapshot.sectionIdentifiers.firstIndex(where: { $0.rawValue == RailingSectionId.carousel.rawValue }) else { return }
        let section = snapshot.sectionIdentifiers[sectionIndex]
        
        section.autoscrollable?.scrollToPage(index, in: collectionView, at: sectionIndex)
        
        if let autoscrollable = section.autoscrollable {
            pauseAutoscrolling(for: section)
        }
    }
}

extension HomeViewController: FavouritesActionsDelegate {
    func favouritesDidTapCard(at index: Int, with externalId: String) {
        router?.routeToPropertyDetail(with: externalId)
    }
    
    func favouritesDidTapViewAll() {
        router?.routeToAllFavorites()
    }
}

extension HomeViewController: SavedSearchesActionsDelegate {
    func savedSearchesDidTapCard(at index: Int) {
        interactor?.didSelectSavedSearch(at: index)
    }
    
    func savedSearchesDidTapViewAll() {
        router?.routeToAllSavedSearches()
    }
}

extension HomeViewController: RecentSearchesActionsDelegate {
    func recentSearchesDidTapCard(at index: Int) {
        interactor?.didSelectRecentSearch(at: index)
    }
}

extension HomeViewController: BlogsActionsDelegate {
    func blogsDidTapCard(with url: String?, title: String?) {
        guard let url = url else { return }
        router?.routeToBlogs(url: url, title: title)
    }
    
    func blogsDidTapViewAll() {
        router?.routeToAllBlogs()
    }
}

extension HomeViewController: NearbyLocationsActionsDelegate {
    func nearbyLocationsDidTapCard(with location: LocationHit) {
        router?.routeToNearbySearch(location: location)
    }
    func nearbyLocationsDidTapAllowLocation() {
        interactor?.requestLocationAuthorization()
    }
}

extension HomeViewController: PopularSearchActionsDelegate {
    func popularSearchDidSelectPurpose(_ purpose: PopularSearchPurpose) {
        interactor?.updatePopularSearchPurpose(purpose: purpose)
    }
    
    func popularSearchDidSelectSearchItem(at index: Int) {
        
    }
}

extension HomeViewController: TruBrokerBannerActionsDelegate {
    func truBrokerBannerDidTap() {
        router?.routeToFindAgents()
    }
}

extension HomeViewController: SellerLeadsBannerActionsDelegate {
    func sellerLeadsBannerDidTap() {
        router?.routeToSellerLeadsForm(purpose: .rent)
    }
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

