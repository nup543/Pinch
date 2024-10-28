//
//  ImageLoader.swift
//  KLMAssignment
//
//  Created by Nupur Sharma on 10/03/2022.
//

import UIKit
import Combine

public class ImageCacheManager {
    public static let shared = ImageCacheManager()
    private let cache: NSCache<NSString, UIImage>
    private init () {
        cache = NSCache()
        cache.countLimit = 75// any number to limit the number of cached image
        cache.totalCostLimit = 25 * 1024 * 1024 // 25 MB macx image memory for cache.
    }

    public func set(image: UIImage, for url: NSString) {
        cache.setObject(image, forKey: url)
    }

    public func getImage(for url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }
}

final class ImageLoader {
    public static let shared = ImageLoader()
    private init() {
        
    }
    
    private let cache = ImageCacheManager.shared
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.getImage(for: url.absoluteString) {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[weak self] image in
                guard let image = image else { return }
                self?.cache.set(image: image, for: url.absoluteString as NSString)
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
