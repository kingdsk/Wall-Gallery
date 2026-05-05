//
//  AWSBucketFolder.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 21/04/21.
//

import Foundation

/// This enum contain all the folder name inside the bucket.
enum AWSBucketFolder {
    
    case user
    case media

    private var folderName: String {
        switch self {
        case .user:
            return "user"
        case .media:
            return "media"
        }
    }
    
    var path: String {
        "\(AWSUploadConfigration.folder.rawValue)\(folderName)/"
    }
}
