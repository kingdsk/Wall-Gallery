//
//  HomeViewModel.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//


import Foundation
import UIKit

final class HomeViewModel {

    // MARK: - Binding Closures
    var onPhotosLoaded: (([UnsplashPhotoModel]) -> Void)?
    var onCachedPhotosLoaded: (([CachedPhoto]) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    // MARK: - Pagination State
    private(set) var currentPage:   Int  = 1
    private(set) var isFetching:    Bool = false
    private(set) var hasMorePages:  Bool = true
    private let perPage = 20

    // MARK: - Data
    private(set) var allPhotos: [UnsplashPhotoModel] = []

    // MARK: - Fetch (Online or Offline)
    func fetchPhotos(page: Int? = nil) {
        let targetPage = page ?? currentPage
        guard !isFetching, hasMorePages else { return }

        // Offline — serve from CoreData
        if !NetworkReachability.shared.isConnected {
            let cached = CoreDataManager.shared.fetchPhotos(forPage: targetPage)
            if cached.isEmpty {
                onError?("No internet connection and no cached data available.")
            } else {
                onCachedPhotosLoaded?(cached)
            }
            return
        }

        // Online — fetch from API
        isFetching = true
        onLoadingStateChanged?(true)

        UnsplashService.shared.fetchPhotos(page: targetPage, perPage: perPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            DispatchQueue.main.async {
                self.onLoadingStateChanged?(false)

                switch result {
                case .success(let photos):
                    if photos.isEmpty {
                        self.hasMorePages = false
                        return
                    }
                    // Cache to CoreData
                    CoreDataManager.shared.savePhotos(photos, page: targetPage)

                    if targetPage == 1 {
                        self.allPhotos = photos
                    } else {
                        self.allPhotos.append(contentsOf: photos)
                    }
                    self.currentPage = targetPage + 1
                    self.onPhotosLoaded?(self.allPhotos)

                case .failure(let error):
                    let cached = CoreDataManager.shared.fetchPhotos(forPage: targetPage)
                    if !cached.isEmpty {
                        self.onCachedPhotosLoaded?(cached)
                    } else {
                        self.onError?("Unable to load images.\nPlease check your connection and try again.")
                    }
                }
            }
        }
    }

    func resetPagination() {
        currentPage  = 1
        isFetching   = false
        hasMorePages = true
        allPhotos    = []
    }
}
