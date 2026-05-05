//
//  CoreDataManager.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//

import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    //------------------------------------------------------
    //MARK: - Stack
    //------------------------------------------------------
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageViewer")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load failed: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    //------------------------------------------------------
    //MARK: - Save Context
    //------------------------------------------------------
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugPrint("CoreData save error: \(error)")
        }
    }

    //------------------------------------------------------
    //MARK: - Save Photos
    //------------------------------------------------------
    func savePhotos(_ photos: [UnsplashPhotoModel], page: Int) {
        deletePhotos(forPage: page)

        photos.forEach { photo in
            let cached              = CachedPhoto(context: context)
            cached.id               = photo.id
            cached.imageURL         = photo.urls.regular
            cached.thumbURL         = photo.urls.thumb
            cached.photographerName = photo.user.name
            cached.photoDescription = photo.description ?? ""
            cached.page             = Int32(page)
            cached.createdAt        = Date()
        }
        saveContext()
    }

    //------------------------------------------------------
    //MARK: - Fetch Photos For Page
    //------------------------------------------------------
    func fetchPhotos(forPage page: Int) -> [CachedPhoto] {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.predicate       = NSPredicate(format: "page == %d", page)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("CoreData fetch error: \(error)")
            return []
        }
    }

    //------------------------------------------------------
    //MARK: - Fetch All Cached Photos
    //------------------------------------------------------
    func fetchAllPhotos() -> [CachedPhoto] {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "page",      ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("CoreData fetchAll error: \(error)")
            return []
        }
    }

    //------------------------------------------------------
    //MARK: - Delete Photos For Page
    //------------------------------------------------------
    private func deletePhotos(forPage page: Int) {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.predicate = NSPredicate(format: "page == %d", page)
        do {
            let existing = try context.fetch(request)
            existing.forEach { context.delete($0) }
            saveContext()
        } catch {
            debugPrint("CoreData delete error: \(error)")
        }
    }

    //------------------------------------------------------
    //MARK: - Check Cache Exists For Page
    //------------------------------------------------------
    func hasCache(forPage page: Int) -> Bool {
        return !fetchPhotos(forPage: page).isEmpty
    }

    //------------------------------------------------------
    //MARK: - Clear All Cache
    //------------------------------------------------------
    func clearAllCache() {
        let request       = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedPhoto")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            debugPrint("CoreData clearAll error: \(error)")
        }
    }
}
