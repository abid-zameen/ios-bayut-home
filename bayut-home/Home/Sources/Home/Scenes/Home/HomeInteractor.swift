//
//  HomeInteractor.swift
//  Home
//
//  Created by Hammad Shahid on 01/04/2026.
//

import Foundation

protocol HomeBusinessLogic: AnyObject {
    func onViewLoad()
    func requestLocationAuthorization()
    func didSelectNewProjectsLocation(id: String) async
    func updatePopularSearchPurpose(purpose: PopularSearchPurpose)
    func didSelectSavedSearch(at index: Int)
    func didSelectRecentSearch(at index: Int)
    func didSelectPopularSearch(at index: Int)
    func onViewAppear()
    func didToggleFavorite(externalId: String)
    func checkOnboarding()
}

final class HomeInteractor: HomeBusinessLogic {
    let adapter: HomeModuleAdapter
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic
    let tracker: HomeTrackerType?
    
    var selectedNewProjectsLocationID: String = Emirates.dubai.rawValue
    
    private var projectsState: Home.DataState<[ProjectHit]> = .loading
    var favouritesState: Home.DataState<[Property]> = .loading
    var blogsState: Home.DataState<[Blog]> = .loading
    var savedSearchesState: Home.DataState<SavedSearchesData> = .loading
    var recentSearchesState: Home.DataState<[HomeScreenRecentSearch]> = .loading
    var nearbyLocationsState: Home.DataState<[LocationHit]> = .loading
    var isLocationAuthorized = false
    var popularSearchPurposes: [PopularSearchPurpose] = []
    var selectedPopularPurpose: PopularSearchPurpose = .buy
    private var showTruBrokerBanner = true
    private var showSellerLeadsBanner = false
    private var popularSearchState: Home.DataState<PopularSearchConfig> = .loading
    private var lastRecentSearchesSignature: String?
    private var lastLanguage: String?
    private var isDataLoaded: Bool = false
    
    private var shouldRefreshUserSpecificData: Bool = false
    private var lastPopularSearchLocationQuery: String?
    
    // MARK: - Initialization
    init(adapter: HomeModuleAdapter, worker: HomeWorkerLogic, tracker: HomeTrackerType) {
        self.adapter = adapter
        self.worker = worker
        self.tracker = tracker
        setupStoriesListener()
        isLocationAuthorized = adapter.environment.isLocationAuthorized
        
        if adapter.environment.shouldFetchPopularSectionViaElasticSearch {
            popularSearchState = .loading
        } else {
            let initialConfig = adapter.utilities.popularSearchConfig
            popularSearchState = .data(initialConfig)
            popularSearchPurposes = initialConfig.purposeConfigs.map { $0.purpose }
            selectedPopularPurpose = popularSearchPurposes.first ?? .rent
        }
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .homeRefreshUserSpecificData, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .loggedIn, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .loggedOut, object: nil)
        
    }
    
    @objc private func handleRefreshUserSpecificData() {
        shouldRefreshUserSpecificData = true
    }
    
    private func setupStoriesListener() {
        adapter.storiesProvider?.onVisibilityChange = { [weak self] _ in
            self?.presentData(animated: true)
        }
    }
    
    private func resetStates() {
        projectsState = .loading
        favouritesState = .loading
        blogsState = .loading
        savedSearchesState = .loading
        recentSearchesState = .loading
        nearbyLocationsState = .loading
        if adapter.environment.shouldFetchPopularSectionViaElasticSearch {
            popularSearchState = .loading
        }
    }
    
    func onViewLoad() {
        lastLanguage = Locale.current.languageCode ?? "en"
        lastPopularSearchLocationQuery = adapter.utilities.popularSectionLocationQuery
        isDataLoaded = true
        self.presentData(animated: true)
        
        checkOnboarding()
        
        Task {
            await self.loadData()
        }
    }
    
    func onViewAppear() {
        guard isDataLoaded else { return }
        adapter.storiesProvider?.updateStoriesOnAppear()
        if let storiesProvider = adapter.storiesProvider, storiesProvider.refreshStoriesIfNeeded() {
            presentData(animated: true)
        }
        
        let currentLanguage = Locale.current.languageCode ?? "en"
        let langChanged = lastLanguage != currentLanguage
        lastLanguage = currentLanguage
        
        let currentPopularLocationQuery = adapter.utilities.popularSectionLocationQuery
        let popularLocationChanged = lastPopularSearchLocationQuery != currentPopularLocationQuery
        
        Task {
            if shouldRefreshUserSpecificData {
                await fetchUserSpecificData()
                shouldRefreshUserSpecificData = false
            }
            
            await fetchPopularSearchConfig()
            let recentSearches = await worker.fetchRecentSearches()
            let newSignature = computeRecentSearchesSignature(recentSearches)
            
            if langChanged || newSignature != lastRecentSearchesSignature {
                recentSearchesState = .loading
                await MainActor.run { presentData(animated: true) }
                
                recentSearchesState = recentSearches.isEmpty ? .empty : .data(recentSearches)
                lastRecentSearchesSignature = newSignature
                await MainActor.run { presentData(animated: true) }
            }
        }
    }
    
    private func computeRecentSearchesSignature(_ searches: [HomeScreenRecentSearch]) -> String {
        return searches.map { "\($0.id)" }.joined(separator: "-")
    }
    
    func loadData() async {
        resetStates()
        calculateBannerVisibility()
        
        DispatchQueue.main.async {
            self.presentData()
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchUserSpecificData() }
            group.addTask { await self.fetchBlogs() }
            group.addTask { await self.fetchRecentSearches() }
            group.addTask { await self.fetchNewProjects() }
            group.addTask { await self.fetchNearbyLocations() }
            group.addTask { await self.fetchPopularSearchConfig(shouldUpdate: true) }
        }
    }
    
    private func fetchUserSpecificData() async {
        guard let userID = adapter.environment.userID else {
            favouritesState = .empty
            savedSearchesState = .empty
            await MainActor.run { presentData() }
            return
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.refreshFavorites() }
            group.addTask { await self.refreshSavedSearches() }
        }
    }
    
    private func refreshSavedSearches() async {
        guard let userID = adapter.environment.userID else {
            savedSearchesState = .empty
            await MainActor.run { presentData() }
            return
        }
        
        do {
            let rawSearches = try await self.worker.fetchSavedSearches(userID: userID)
            let slicedSearches = Array(rawSearches.prefix(5))
            
            if !slicedSearches.isEmpty {
                let allSlugs = slicedSearches.compactMap { $0.params.locations }.flatMap { $0 }
                let uniqueSlugs = Array(Set(allSlugs))
                let resolvedLocations = try await self.worker.fetchLocations(slugs: uniqueSlugs)
                self.savedSearchesState = .data(SavedSearchesData(searches: slicedSearches, resolvedLocations: resolvedLocations))
            } else {
                self.savedSearchesState = .empty
            }
        } catch {
            self.savedSearchesState = .empty
        }
        await MainActor.run { self.presentData() }
    }

    private func fetchBlogs() async {
        do {
            let blogs = try await worker.fetchLatestBlogs()
            let sliced = Array(blogs.prefix(5))
            blogsState = sliced.isEmpty ? .empty : .data(sliced)
        } catch {
            blogsState = .empty
        }
        await MainActor.run { presentData() }
    }
    
    private func fetchRecentSearches() async {
        let recent = await worker.fetchRecentSearches()
        recentSearchesState = recent.isEmpty ? .empty : .data(recent)
        await MainActor.run { presentData() }
    }
    
    private func fetchNewProjects() async {
        let cplIDs = adapter.utilities.supportedLocIDsCPL[selectedNewProjectsLocationID]
        let projects = await worker.fetchNewProjects(locationID: selectedNewProjectsLocationID, cplIDs: cplIDs)
        projectsState = projects.isEmpty ? .empty : .data(projects)
        await MainActor.run { presentData() }
    }
    
    private func fetchNearbyLocations() async {
        guard !adapter.environment.isOnboardingInProgress else {
            return
        }
        
        guard isLocationAuthorized, let coords = adapter.environment.userCoordinates else {
            nearbyLocationsState = .empty
            await MainActor.run { presentData() }
            return
        }
        
        do {
            let locations = try await worker.fetchNearbyLocations(latitude: coords.lat, longitude: coords.lon)
            nearbyLocationsState = locations.isEmpty ? .empty : .data(locations)
        } catch {
            nearbyLocationsState = .empty
        }
        await MainActor.run { presentData() }
    }
    
    private func fetchPopularSearchConfig(shouldUpdate: Bool = false) async {
        guard adapter.environment.shouldFetchPopularSectionViaElasticSearch else { return }
        
        var locationQuery = adapter.utilities.popularSectionLocationQuery ?? "location_id:total"
        
        guard shouldUpdate || locationQuery != lastPopularSearchLocationQuery else { return }
        lastPopularSearchLocationQuery = locationQuery
        
        popularSearchState = .loading
        await MainActor.run { presentData() }
        
        do {
                        
            var metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
            
            if (metadata.responses?.first?.aggregations?.group?.buckets?.isEmpty ?? true) &&
                (metadata.responses?.count ?? 0 > 1 && metadata.responses?[1].aggregations?.group?.buckets?.isEmpty ?? true) {
                if let parentQuery = adapter.utilities.popularSectionParentLocationQuery {
                    locationQuery = parentQuery
                    metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
                }
            }
            
            // Fallback logic 2: Total
            if (metadata.responses?.first?.aggregations?.group?.buckets?.isEmpty ?? true) &&
                (metadata.responses?.count ?? 0 > 1 && metadata.responses?[1].aggregations?.group?.buckets?.isEmpty ?? true) &&
                locationQuery != "location_id:total" {
                locationQuery = "location_id:total"
                metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
            }
            
            var saleCategories: [PopularSearchCategory] = []
            var rentCategories: [PopularSearchCategory] = []
            
            if let responses = metadata.responses, responses.count > 1 {
                if let saleBuckets = responses[0].aggregations?.group?.buckets {
                    saleCategories = saleBuckets.compactMap { bucket in
                        guard let idString = bucket.key, let id = Int(idString) else { return nil }
                        return adapter.utilities.getPopularSearchCategory(for: id)
                    }
                }
                
                if let rentBuckets = responses[1].aggregations?.group?.buckets {
                    rentCategories = rentBuckets.compactMap { bucket in
                        guard let idString = bucket.key, let id = Int(idString) else { return nil }
                        return adapter.utilities.getPopularSearchCategory(for: id)
                    }
                }
                
                var configs: [PopularSearchPurposeConfig] = []
                if !saleCategories.isEmpty {
                    configs.append(PopularSearchPurposeConfig(purpose: .buy, categories: saleCategories))
                }
                if !rentCategories.isEmpty {
                    configs.append(PopularSearchPurposeConfig(purpose: .rent, categories: rentCategories))
                }
                
                if !configs.isEmpty {
                    let newConfig = PopularSearchConfig(purposeConfigs: configs)
                    await MainActor.run {
                        self.popularSearchState = .data(newConfig)
                        self.popularSearchPurposes = newConfig.purposeConfigs.map { $0.purpose }
                        if !self.popularSearchPurposes.contains(self.selectedPopularPurpose) {
                            self.selectedPopularPurpose = self.popularSearchPurposes.first ?? .rent
                        }
                        self.presentData()
                    }
                }
            }
        } catch {
            let initialConfig = adapter.utilities.popularSearchConfig
            self.popularSearchState = .data(initialConfig)
            self.popularSearchPurposes = initialConfig.purposeConfigs.map { $0.purpose }
            if !self.popularSearchPurposes.contains(self.selectedPopularPurpose) {
                self.selectedPopularPurpose = self.popularSearchPurposes.first ?? .rent
            }
            await MainActor.run { self.presentData() }
        }
    }
    
    private func calculateBannerVisibility() {
        guard adapter.environment.isSellerLeadsEnabled else {
            showTruBrokerBanner = true
            showSellerLeadsBanner = false
            return
        }
        
        let randomValue = Int.random(in: 0...100)
        showTruBrokerBanner = randomValue <= 40
        showSellerLeadsBanner = !showTruBrokerBanner
    }
    
    func presentData(animated: Bool = false) {
        let response = Home.Response(
            projects: projectsState,
            locations: [],
            selectedNewProjectsLocationID: selectedNewProjectsLocationID,
            favourites: favouritesState,
            savedSearches: savedSearchesState,
            blogs: blogsState,
            nearbyLocations: nearbyLocationsState,
            isLocationEnabled: isLocationAuthorized,
            popularSearchState: popularSearchState,
            purposes: popularSearchPurposes,
            selectedPurpose: selectedPopularPurpose,
            recentSearches: recentSearchesState,
            showTruBrokerBanner: showTruBrokerBanner,
            showSellerLeadsBanner: showSellerLeadsBanner
        )
        presenter?.presentData(data: response, animated: animated)
    }
    
    func requestLocationAuthorization() {
        adapter.environment.requestLocationAuthorization()
    }
    
    func updatePopularSearchPurpose(purpose: PopularSearchPurpose) {
        self.selectedPopularPurpose = purpose
        presentData()
    }
    
    func didSelectNewProjectsLocation(id: String) async {
        guard selectedNewProjectsLocationID != id else { return }
        selectedNewProjectsLocationID = id
        
        projectsState = .loading
        await MainActor.run { presentData() }
        
        let cplIDs = adapter.utilities.supportedLocIDsCPL[id]
        let projects = await worker.fetchNewProjects(locationID: id, cplIDs: cplIDs)
        projectsState = projects.isEmpty ? .empty : .data(projects)
        
        await MainActor.run { presentData() }
    }
    
    func didSelectSavedSearch(at index: Int) {
        guard case .data(let savedSearches) = savedSearchesState else { return }
        
        let search = savedSearches.searches[index]
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(search),
           let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            presenter?.presentSavedSearchRouting(savedSearchData: dict, resolvedLocations: savedSearches.resolvedLocations)
        }
    }
    
    func didSelectRecentSearch(at index: Int) {
        guard case .data(let recentSearches) = recentSearchesState,
              index < recentSearches.count else { return }
        let search = recentSearches[index]
        presenter?.presentRecentSearchRouting(search: search)
    }
    
    func didSelectPopularSearch(at index: Int) {
        guard case .data(let config) = popularSearchState else { return }
        let purposeConfig = config.purposeConfigs.first { $0.purpose == selectedPopularPurpose }
        guard let categories = purposeConfig?.categories, index < categories.count else { return }
        let category = categories[index]
        presenter?.presentPopularSearchRouting(category: category, purpose: selectedPopularPurpose)
    }
    
    func didToggleFavorite(externalId: String) {
        guard let userID = adapter.environment.userID else { return }
        
        favouritesState = .loading
        presentData()
        
        Task {
            do {
                try await worker.toggleFavorite(userID: userID, externalID: externalId)
                await refreshFavorites()
            } catch {
                await refreshFavorites()
            }
        }
    }
    
    private func refreshFavorites() async {
        guard let userID = adapter.environment.userID else {
            favouritesState = .empty
            await MainActor.run { presentData() }
            return
        }
        
        do {
            let favIds = try await self.worker.fetchFavoritesIDs(userID: userID)
            let slicedFavIds = Array(favIds.prefix(5))
            if !slicedFavIds.isEmpty {
                let properties = try await self.worker.fetchFavoritesProperties(ids: slicedFavIds)
                let resolved = slicedFavIds.compactMap { id in
                    properties.first(where: { $0.id == id })
                }
                self.favouritesState = resolved.isEmpty ? .empty : .data(resolved)
            } else {
                self.favouritesState = .empty
            }
        } catch {
            self.favouritesState = .empty
        }
        await MainActor.run { self.presentData() }
    }
    
    func checkOnboarding() {
        let env = adapter.environment
        guard env.isAppOnboardingEnabled, !env.wasDeepLinkInitiated, !env.hasDisplayedOnboarding else {
            return
        }
        
        if env.isOnboardingV2Enabled {
            presenter?.presentOnboardingV2()
        } else {
            presenter?.presentOnboarding()
        }
    }
}
