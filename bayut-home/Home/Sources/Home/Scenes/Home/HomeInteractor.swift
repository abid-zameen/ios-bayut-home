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
    func didTapWhatsapp(for hit: ProjectHit, index: Int)
}

final class HomeInteractor: HomeBusinessLogic {
    let adapter: HomeModuleAdapter
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic
    let tracker: HomeTrackerType?
    var sectionsData = Home.SectionsDataState()
    
    // MARK: - Initialization
    init(adapter: HomeModuleAdapter, worker: HomeWorkerLogic, tracker: HomeTrackerType) {
        self.adapter = adapter
        self.worker = worker
        self.tracker = tracker
        setupStoriesListener()
        sectionsData.nearbyLocations.isAuthorized = adapter.environment.isLocationAuthorized
        
        if adapter.environment.shouldFetchPopularSectionViaElasticSearch {
            sectionsData.popularSearch.state = .loading
        } else {
            let initialConfig = adapter.utilities.popularSearchConfig
            sectionsData.popularSearch.state = .data(initialConfig)
            sectionsData.popularSearch.purposes = initialConfig.purposeConfigs.map { $0.purpose }
            sectionsData.popularSearch.selectedPurpose = sectionsData.popularSearch.purposes.first ?? .rent
        }
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .homeRefreshUserSpecificData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .loggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUserSpecificData), name: .loggedOut, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecentSearchRefresh), name: .refreshRecentSeachesOnHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopularSearchesRefresh), name: .refreshPopularSearchesOnHome, object: nil)
    }
    
    @objc private func handleRefreshUserSpecificData() {
        sectionsData.shouldRefreshUserSpecificData = true
    }
    
    @objc private func handleRecentSearchRefresh() {
        sectionsData.shouldRefreshRecentSearches = true
    }
    
    @objc private func handlePopularSearchesRefresh() {
        sectionsData.popularSearch.shouldRefresh = true
    }
    
    private func setupStoriesListener() {
        adapter.storiesProvider?.onVisibilityChange = { [weak self] _ in
            self?.presentData(animated: true)
        }
    }
    
    // MARK: - Lifecycle
    func onViewLoad() {
        sectionsData.lastLanguage = Locale.current.languageCode ?? "en"
        sectionsData.isDataLoaded = true
        self.presentData(animated: true)
        
        checkOnboarding()
        
        Task {
            await self.loadData()
        }
    }
    
    func onViewAppear() {
        guard sectionsData.isDataLoaded else { return }
        
        if adapter.environment.shouldShowAppReview {
            presenter?.presentAppReview()
        }
        
        adapter.storiesProvider?.updateStoriesOnAppear()
        
        var shouldPresentImmediately = false
        if let storiesProvider = adapter.storiesProvider, storiesProvider.refreshStoriesIfNeeded() {
            shouldPresentImmediately = true
        }
        
        let currentLanguage = Locale.current.languageCode ?? "en"
        let langChanged = sectionsData.lastLanguage != currentLanguage
        sectionsData.lastLanguage = currentLanguage
        
        if sectionsData.shouldRefreshRecentSearches || langChanged {
            sectionsData.recentSearches.state = .loading
            shouldPresentImmediately = true
        }
        
        fetchLocalListingStatus()
        if case .data(let currentFavs) = sectionsData.favourites {
            let updatedFavs = applyStatusToProperties(currentFavs)
            sectionsData.favourites = .data(updatedFavs)
            shouldPresentImmediately = true
        }
        
        if shouldPresentImmediately {
            presentData(animated: true)
        }
        
        Task {
            if sectionsData.shouldRefreshUserSpecificData {
                await fetchUserSpecificData()
                sectionsData.shouldRefreshUserSpecificData = false
            }
            
            if sectionsData.popularSearch.shouldRefresh {
                await fetchPopularSearchConfig()
                sectionsData.popularSearch.shouldRefresh = false
            }
            
            if sectionsData.shouldRefreshRecentSearches || langChanged {
                let recentSearches = await worker.fetchRecentSearches()
                sectionsData.recentSearches.state = recentSearches.isEmpty ? .empty : .data(recentSearches)
                sectionsData.shouldRefreshRecentSearches = false
                await MainActor.run { presentData(animated: true) }
            }
        }
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
            group.addTask { await self.fetchPopularSearchConfig() }
        }
    }
    
    func presentData(animated: Bool = false) {
        let response = Home.Response(
            projects: sectionsData.projects.state,
            selectedNewProjectsLocationID: sectionsData.projects.selectedLocationID,
            favourites: sectionsData.favourites,
            savedSearches: sectionsData.savedSearches,
            blogs: sectionsData.blogs,
            nearbyLocations: sectionsData.nearbyLocations.state,
            isLocationEnabled: sectionsData.nearbyLocations.isAuthorized,
            popularSearchState: sectionsData.popularSearch.state,
            purposes: sectionsData.popularSearch.purposes,
            selectedPurpose: sectionsData.popularSearch.selectedPurpose,
            recentSearches: sectionsData.recentSearches.state,
            showTruBrokerBanner: sectionsData.banners.showTruBroker,
            showSellerLeadsBanner: sectionsData.banners.showSellerLeads,
            popularSearchDisplayedLocation: sectionsData.popularSearch.displayedLocationName
        )
        presenter?.presentData(data: response, animated: animated)
    }
    
    // MARK: - Helpers
    private func resetStates() {
        sectionsData.projects.state = .loading
        sectionsData.favourites = .loading
        sectionsData.blogs = .loading
        sectionsData.savedSearches = .loading
        sectionsData.recentSearches.state = .loading
        sectionsData.nearbyLocations.state = .loading
        if adapter.environment.shouldFetchPopularSectionViaElasticSearch {
            sectionsData.popularSearch.state = .loading
        }
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
    
    func didTapWhatsapp(for hit: ProjectHit, index: Int) {
        HomeModule.shared.ovation.sendProjectWhatsappLead(hit: hit, listingPosition: index)
    }
}

// MARK: - User Specific Data Logic
extension HomeInteractor {
    private func fetchUserSpecificData() async {
        await adapter.environment.syncFavourites()
        fetchLocalListingStatus()
        
        guard let userID = adapter.environment.userID else {
            await refreshFavorites()
            sectionsData.savedSearches = .empty
            await MainActor.run { presentData() }
            return
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.refreshFavorites() }
            group.addTask { await self.refreshSavedSearches() }
        }
    }
}

// MARK: - Favourites Section Logic
extension HomeInteractor {
    func didToggleFavorite(externalId: String) {
        if let userID = adapter.environment.userID {
            sectionsData.favourites = .loading
            presentData()
            
            Task {
                do {
                    try await worker.toggleFavorite(userID: userID, externalID: externalId)
                    await refreshFavorites()
                } catch {
                    await refreshFavorites()
                }
            }
        } else if adapter.environment.isFavouritesWithoutLoginEnabled {
            adapter.environment.toggleLocalFavorite(externalID: externalId)
            Task {
                await refreshFavorites()
            }
        }
    }
    
    private func refreshFavorites() async {
        let env = adapter.environment
        if let userID = env.userID {
            do {
                let favIds = try await self.worker.fetchFavoritesIDs(userID: userID)
                let slicedFavIds = Array(favIds.prefix(5))
                if !slicedFavIds.isEmpty {
                    let properties = try await self.worker.fetchFavoritesProperties(ids: slicedFavIds)
                    let resolved = slicedFavIds.compactMap { id in
                        properties.first(where: { $0.id == id })
                    }
                    let finalized = applyStatusToProperties(resolved)
                    self.sectionsData.favourites = finalized.isEmpty ? .empty : .data(finalized)
                } else {
                    self.sectionsData.favourites = .empty
                }
            } catch {
                self.sectionsData.favourites = .empty
            }
        } else if env.isFavouritesWithoutLoginEnabled && !env.unsyncedFavouriteIDs.isEmpty {
            do {
                let favIds = env.unsyncedFavouriteIDs
                let slicedFavIds = Array(favIds.prefix(5).reversed())
                let properties = try await self.worker.fetchFavoritesProperties(ids: slicedFavIds)
                let resolved = slicedFavIds.compactMap { id in
                    properties.first(where: { $0.id == id })
                }
                let finalized = applyStatusToProperties(resolved)
                self.sectionsData.favourites = finalized.isEmpty ? .empty : .data(finalized)
            } catch {
                self.sectionsData.favourites = .empty
            }
        } else {
            self.sectionsData.favourites = .empty
        }
        await MainActor.run { self.presentData() }
    }
    
    private func fetchLocalListingStatus() {
        sectionsData.viewedListingIDs = Set(adapter.environment.viewedListingIDs)
        sectionsData.contactedListingIDs = Set(adapter.environment.contactedListingIDs)
    }
    
    private func applyStatusToProperties(_ properties: [Property]) -> [Property] {
        return properties.map { property in
            var p = property
            p.isViewed = sectionsData.viewedListingIDs.contains(p.id)
            p.isContacted = sectionsData.contactedListingIDs.contains(p.id)
            return p
        }
    }
}

// MARK: - Blogs Section Logic
extension HomeInteractor {
    private func fetchBlogs() async {
        do {
            let blogs = try await worker.fetchLatestBlogs()
            let sliced = Array(blogs.prefix(5))
            sectionsData.blogs = sliced.isEmpty ? .empty : .data(sliced)
        } catch {
            sectionsData.blogs = .empty
        }
        await MainActor.run { presentData() }
    }
}

// MARK: - Saved Searches Section Logic
extension HomeInteractor {
    private func refreshSavedSearches() async {
        guard let userID = adapter.environment.userID else {
            sectionsData.savedSearches = .empty
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
                self.sectionsData.savedSearches = .data(SavedSearchesData(searches: slicedSearches, resolvedLocations: resolvedLocations))
            } else {
                self.sectionsData.savedSearches = .empty
            }
        } catch {
            self.sectionsData.savedSearches = .empty
        }
        await MainActor.run { self.presentData() }
    }
    
    func didSelectSavedSearch(at index: Int) {
        guard case .data(let savedSearches) = sectionsData.savedSearches else { return }
        
        let search = savedSearches.searches[index]
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(search),
           let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            presenter?.presentSavedSearchRouting(savedSearchData: dict, resolvedLocations: savedSearches.resolvedLocations)
        }
    }
}

// MARK: - Recent Searches Section Logic
extension HomeInteractor {
    private func fetchRecentSearches() async {
        let recent = await worker.fetchRecentSearches()
        sectionsData.recentSearches.state = recent.isEmpty ? .empty : .data(recent)
        await MainActor.run { presentData() }
    }
    
    func didSelectRecentSearch(at index: Int) {
        guard case .data(let recentSearches) = sectionsData.recentSearches.state,
              index < recentSearches.count else { return }
        let search = recentSearches[index]
        presenter?.presentRecentSearchRouting(search: search)
    }
}

// MARK: - New Projects Section Logic
extension HomeInteractor {
    private func fetchNewProjects() async {
        let cplIDs = adapter.utilities.supportedLocIDsCPL[sectionsData.projects.selectedLocationID]
        let projects = await worker.fetchNewProjects(locationID: sectionsData.projects.selectedLocationID, cplIDs: cplIDs)
        sectionsData.projects.state = projects.isEmpty ? .empty : .data(projects)
        await MainActor.run { presentData() }
    }
    
    func didSelectNewProjectsLocation(id: String) async {
        guard sectionsData.projects.selectedLocationID != id else { return }
        sectionsData.projects.selectedLocationID = id
        
        sectionsData.projects.state = .loading
        await MainActor.run { presentData(animated: true) }
        
        let cplIDs = adapter.utilities.supportedLocIDsCPL[id]
        let projects = await worker.fetchNewProjects(locationID: id, cplIDs: cplIDs)
        sectionsData.projects.state = projects.isEmpty ? .empty : .data(projects)
        
        await MainActor.run { presentData(animated: true) }
    }
}

// MARK: - Popular Search Section Logic
 extension HomeInteractor {
    private func fetchPopularSearchConfig() async {
        guard adapter.environment.shouldFetchPopularSectionViaElasticSearch else { return }
        
        var locationQuery = adapter.utilities.popularSectionLocationQuery ?? "location_id:total"
        
        sectionsData.popularSearch.state = .loading
        await MainActor.run { presentData() }
        
        do {
            var metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
            var displayedLocationName = adapter.utilities.popularSectionLocationName
            
            if (metadata.responses?.first?.aggregations?.group?.buckets?.isEmpty ?? true) &&
                (metadata.responses?.count ?? 0 > 1 && metadata.responses?[1].aggregations?.group?.buckets?.isEmpty ?? true) {
                if let parentQuery = adapter.utilities.popularSectionParentLocationQuery {
                    locationQuery = parentQuery
                    metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
                }
            }
            
            if (metadata.responses?.first?.aggregations?.group?.buckets?.isEmpty ?? true) &&
                (metadata.responses?.count ?? 0 > 1 && metadata.responses?[1].aggregations?.group?.buckets?.isEmpty ?? true) &&
                locationQuery != "location_id:total" {
                locationQuery = "location_id:total"
                displayedLocationName = nil
                metadata = try await worker.fetchPopularSectionMetadata(locationQuery: locationQuery)
            }
            
            sectionsData.popularSearch.displayedLocationName = displayedLocationName
            
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
                        self.sectionsData.popularSearch.state = .data(newConfig)
                        self.sectionsData.popularSearch.purposes = newConfig.purposeConfigs.map { $0.purpose }
                        if !self.sectionsData.popularSearch.purposes.contains(self.sectionsData.popularSearch.selectedPurpose) {
                            self.sectionsData.popularSearch.selectedPurpose = self.sectionsData.popularSearch.purposes.first ?? .rent
                        }
                        self.presentData()
                    }
                }
            }
        } catch {
            let initialConfig = adapter.utilities.popularSearchConfig
            self.sectionsData.popularSearch.state = .data(initialConfig)
            self.sectionsData.popularSearch.purposes = initialConfig.purposeConfigs.map { $0.purpose }
            if !self.sectionsData.popularSearch.purposes.contains(self.sectionsData.popularSearch.selectedPurpose) {
                self.sectionsData.popularSearch.selectedPurpose = self.sectionsData.popularSearch.purposes.first ?? .rent
            }
            await MainActor.run { self.presentData() }
        }
    }
    
    func updatePopularSearchPurpose(purpose: PopularSearchPurpose) {
        self.sectionsData.popularSearch.selectedPurpose = purpose
        presentData()
    }
    
    func didSelectPopularSearch(at index: Int) {
        guard case .data(let config) = sectionsData.popularSearch.state else { return }
        let purposeConfig = config.purposeConfigs.first { $0.purpose == sectionsData.popularSearch.selectedPurpose }
        guard let categories = purposeConfig?.categories, index < categories.count else { return }
        let category = categories[index]
        presenter?.presentPopularSearchRouting(category: category, purpose: sectionsData.popularSearch.selectedPurpose)
    }
}

// MARK: - Nearby Locations Section Logic
extension HomeInteractor {
    private func fetchNearbyLocations() async {
        guard !adapter.environment.isOnboardingInProgress else { return }
        
        guard sectionsData.nearbyLocations.isAuthorized, let coords = adapter.environment.userCoordinates else {
            sectionsData.nearbyLocations.state = .empty
            await MainActor.run { presentData() }
            return
        }
        
        do {
            let locations = try await worker.fetchNearbyLocations(latitude: coords.lat, longitude: coords.lon)
            sectionsData.nearbyLocations.state = locations.isEmpty ? .empty : .data(locations)
        } catch {
            sectionsData.nearbyLocations.state = .empty
        }
        await MainActor.run { presentData() }
    }
    
    func requestLocationAuthorization() {
        adapter.environment.requestLocationAuthorization()
    }
}

// MARK: - Banner Logic
private extension HomeInteractor {
    func calculateBannerVisibility() {
        guard adapter.environment.isSellerLeadsEnabled else {
            sectionsData.banners.showTruBroker = true
            sectionsData.banners.showSellerLeads = false
            return
        }
        
        let randomValue = Int.random(in: 0...100)
        sectionsData.banners.showTruBroker = randomValue <= 40
        sectionsData.banners.showSellerLeads = !sectionsData.banners.showTruBroker
    }
}
