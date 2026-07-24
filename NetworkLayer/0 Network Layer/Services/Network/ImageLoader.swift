//
//  ImageLoader.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/07/26.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private var tasks: [UUID: URLSessionDataTask] = [:]

    private init() {}

    @discardableResult
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> UUID {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return UUID()
        }

        let imageRequestID = UUID()

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            defer {
                self?.tasks[imageRequestID] = nil
            }

            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self?.cache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                completion(image)
            }
        }

        tasks[imageRequestID] = task
        task.resume()

        return imageRequestID
    }

    func cancelLoad(for imageRequestID: UUID?) {
        guard let imageRequestID else { return }
        tasks[imageRequestID]?.cancel()
        tasks[imageRequestID] = nil
    }
}
