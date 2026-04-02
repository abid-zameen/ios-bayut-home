import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displaySections(viewModel: Home.HomeViewModel)
}

final class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    
    // MARK: - Private Properties
    private var dataSource: UICollectionViewDiffableDataSource<AnySection, AnyHashable>!

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Constants
    private enum Constants {
        static let scrollAnimationOffset: CGFloat = 10
        static let scrollOffset: CGFloat = 24
    }
    
    // MARK: - Init (VIP Setup)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupVIP()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupVIP()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureDataSource()
        interactor?.loadData()
    }
    
    // MARK: - Display Logic
    func displaySections(viewModel: Home.HomeViewModel) {
        applySnapshot(sections: viewModel.sections, animated: viewModel.animated)
    }
 
}



// MARK: - Setup
private extension HomeViewController {
    
    func setupVIP() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func setupViews() {
        CellRegistry.registerCells(in: collectionView)
        collectionView.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        let leadingTarget: NSLayoutXAxisAnchor
        let trailingTarget: NSLayoutXAxisAnchor
        
//        if isIPad {
//            leadingTarget = view.readableContentGuide.leadingAnchor
//            trailingTarget = view.readableContentGuide.trailingAnchor
//        } else {
            leadingTarget = view.leadingAnchor
            trailingTarget = view.trailingAnchor
        //}
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingTarget),
            collectionView.trailingAnchor.constraint(equalTo: trailingTarget),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate (Scroll Logic)
extension HomeViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        //        let request = TruEstimateReport.SelectItem.Request(
        //            indexPath: indexPath,
        //            item: item,
        //            section: section
        //        )
        //        interactor?.selectItem(request: request)
        section.didSelectItem(at: indexPath, with: item)
    }
}

// MARK: - NewProjectsActionsDelegate
extension HomeViewController: NewProjectsActionsDelegate {
    func newProjectsDidTapCard(at index: Int) {
        print("Tapped New Project Card at index: \(index)")
    }
    
    func newProjectsDidTapLocationChip(externalID: String) {
        print("Tapped Location Chip with ID: \(externalID)")
    }
    
    func newProjectsDidTapViewAll() {
        print("Tapped View All New Projects")
    }
}

// MARK: - RailingActionsDelegate
extension HomeViewController: RailingActionsDelegate {
    func railingDidTapCard(at index: Int) {
        print("Tapped Railing Card at index: \(index)")
    }
    
    func railingDidTapPageControl(index: Int) {
//        // Find the native Diffable Section index for the Carousel explicitly
//        let snapshot = dataSource.snapshot()
//        if let sectionIndex = snapshot.sectionIdentifiers.firstIndex(where: { ($0.identifier as? RailingSectionId) == .carousel }) {
//            let indexPath = IndexPath(item: index, section: sectionIndex)
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
    }
}

extension HomeViewController: FavouritesActionsDelegate {
    func favouritesDidTapCard(at index: Int) {
        
    }
    
    func favouritesDidTapViewAll() {
        
    }
}

extension HomeViewController: SavedSearchesActionsDelegate {
    func savedSearchesDidTapCard(at index: Int) {
        print("Tapped Saved Search Card at index: \(index)")
    }
    
    func savedSearchesDidTapViewAll() {
        print("Tapped View All Saved Searches")
    }
}

extension HomeViewController: BlogsActionsDelegate {
    func blogsDidTapCard(at index: Int) {
        print("Tapped Blog Card at index: \(index)")
    }
    
    func blogsDidTapViewAll() {
        print("Tapped View All Blogs")
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
            return self.configureCell(collectionView: collectionView, indexPath: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            return self.configureSupplementaryView(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
    }
    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        return section.configureCell(in: collectionView, at: indexPath, with: item)
    }
    
    func configureSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        return section.configureSupplementaryView(in: collectionView, kind: kind, at: indexPath) ?? UICollectionReusableView()
    }
    
    func applySnapshot(sections: [AnySection], animated: Bool) {
        let currentSnapshot = dataSource.snapshot()
        var newSnapshot = NSDiffableDataSourceSnapshot<AnySection, AnyHashable>()
        newSnapshot.appendSections(sections)
        
        for section in sections {
            let items = section.buildItems()
            if !items.isEmpty {
                newSnapshot.appendItems(items, toSection: section)
            }
        }
        
        let currentItems = Set(currentSnapshot.itemIdentifiers)
        let itemsToReconfigure = newSnapshot.itemIdentifiers.filter { currentItems.contains($0) }
        newSnapshot.reconfigureItems(itemsToReconfigure)
        dataSource.apply(newSnapshot, animatingDifferences: animated)
    }
}
