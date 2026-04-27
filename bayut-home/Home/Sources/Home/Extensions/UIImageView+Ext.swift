//
//  UIImageView+Ext.swift
//  Home
//
//  Created by Hammad Shahid on 27/04/2026.
//
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Loads an image from a URL with caching and an optional placeholder.
    /// - Parameters:
    ///   - url: The URL of the image to load.
    ///   - placeholder: An optional custom placeholder image.
    ///   - completion: A completion block called after the image load finishes.
    func loadImage(
        with url: URL?,
        placeholder: UIImage? = nil,
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        // Fallback to the default application placeholder if none is provided
        let defaultPlaceholder = placeholder ?? UIImage(named: "imagePlaceholder", in: .module, with: nil)
        
        kf.setImage(
            with: url,
            placeholder: defaultPlaceholder,
            options: [
                .transition(.fade(0.2)),
                .cacheSerializer(DefaultCacheSerializer.default)
            ],
            completionHandler: { result in
                switch result {
                case .success(let imageResult):
                    completion?(.success(imageResult.image))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        )
    }
}
