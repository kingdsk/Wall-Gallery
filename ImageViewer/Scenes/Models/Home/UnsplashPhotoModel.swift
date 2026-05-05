//
//  UnsplashPhotoModel.swift
//  ImageViewer
//
//  Created by hyperlink on 05/05/26.
//

import Foundation

struct UnsplashPhotoModel: Codable {
    let id:          String
    let urls:        PhotoURLs
    let user:        PhotoUser
    let description: String?
    let altDescription: String?

    struct PhotoURLs: Codable {
        let raw:     String?
        let full:    String?
        let regular: String?
        let small:   String?
        let thumb:   String?
    }

    struct PhotoUser: Codable {
        let name:     String
        let username: String

        enum CodingKeys: String, CodingKey {
            case name
            case username
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case description
        case altDescription = "alt_description"
    }
}
