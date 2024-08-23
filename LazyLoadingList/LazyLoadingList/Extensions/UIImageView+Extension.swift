//
//  UIImageView+Extension.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    public func loadImageUsingCache(withUrl urlString : String, placeholderImage: UIImage? = nil, completion: ((_ imageView: UIImageView) -> Void)? = nil) {
        self.image = placeholderImage
        
        guard let url = URL(string: urlString) else { return }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            completion?(self)
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data, !data.isEmpty else {
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    completion?(self)
                }
            }
        }).resume()
    }
    
}
