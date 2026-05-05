//
//  GExtension+UIImageView.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import ImageIO
import SimpleImageViewer
import SDWebImage

extension UIImageView {
    
    /// Sets image from image URL.
    /// - Parameters:
    ///   - url: Image URL
    ///   - placeholder: Placeholder image
    ///   - loader: Flag for show loader or not
    ///   - completed: Completion block after download image
    func setImage(with url: String, placeholder: UIImage? = nil , andLoader loader: Bool = true, completed: SDExternalCompletionBlock? = nil) {

          guard let imageURL = URL(string: url) else { return }

          //print("url--",imageURL)
          sd_imageTransition = .fade

          if loader {
              self.sd_imageIndicator = SDWebImageActivityIndicator.gray
          }
          sd_setImage(with: imageURL, placeholderImage: placeholder, options:[.retryFailed, .refreshCached], completed: completed)
      }
    
    /**
     Tap to open full screen image preview
     - Parameter image: UIImage for preview
     */
    func tapToZoom(with image: UIImage? = nil) {
        self.addTapGestureRecognizer {
            self.zoomImage(with: image)
        }
    }
    
    /**
     Full screen image preview
     - Parameter image: UIImage for preview
     */
    func zoomImage(with image: UIImage?) {
        
        if let _ = self.image {
            let configuration = ImageViewerConfiguration { config in
                config.imageView = self
                if image != nil {
                    config.image = image
                }
            }
            let imageViewerController = ImageViewerController(configuration: configuration)
            imageViewerController.navigationController?.navigationBar.isHidden = false
            UIApplication.topViewController()?.present(imageViewerController, animated: true, completion: nil)
        }
    }
}
