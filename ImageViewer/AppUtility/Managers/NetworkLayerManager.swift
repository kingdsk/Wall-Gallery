//
//  NetworkLayerManager.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//

import Foundation
import Network

// MARK: - Unsplash API Service
final class UnsplashService {

    static let shared = UnsplashService()
    private init() {}

    private let accessKey = AppCredential.secretKey.rawValue
    private let baseURL   = "https://api.unsplash.com/photos"

    //------------------------------------------------------
    //MARK: - Fetch Photos
    //------------------------------------------------------
    func fetchPhotos(page: Int,
                     perPage: Int = 20,
                     completion: @escaping (Result<[UnsplashPhotoModel], Error>) -> Void) {

        let urlString = "\(baseURL)?page=\(page)&per_page=\(perPage)&client_id=\(accessKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(
                domain: "UnsplashAPI",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
            )))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            //------------------------------------------------------
            //MARK: - Network Error
            //------------------------------------------------------
            if let error = error {
                completion(.failure(error))
                return
            }

            //------------------------------------------------------
            //MARK: - HTTP Status Check
            //------------------------------------------------------
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                let err = NSError(
                    domain: "UnsplashAPI",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"]
                )
                completion(.failure(err))
                return
            }

            //------------------------------------------------------
            //MARK: - Data Check
            //------------------------------------------------------
            guard let data = data else {
                completion(.failure(NSError(
                    domain: "UnsplashAPI",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"]
                )))
                return
            }

            //------------------------------------------------------
            //MARK: - Decode
            //------------------------------------------------------
            do {
                let photos = try JSONDecoder().decode([UnsplashPhotoModel].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}

// MARK: - Network Reachability
final class NetworkReachability {

    static let shared = NetworkReachability()
    private let monitor = NWPathMonitor()
    private(set) var isConnected: Bool = true
    var onStatusChange: ((Bool) -> Void)?

    //------------------------------------------------------
    //MARK: - Init
    //------------------------------------------------------
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connected        = path.status == .satisfied
            self.isConnected     = connected
            self.onStatusChange?(connected)
        }

        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)

        //------------------------------------------------------
        //MARK: - Read Initial Network Status
        //------------------------------------------------------
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
            let currentPath  = self.monitor.currentPath
            self.isConnected = currentPath.status == .satisfied
        }
    }
}
