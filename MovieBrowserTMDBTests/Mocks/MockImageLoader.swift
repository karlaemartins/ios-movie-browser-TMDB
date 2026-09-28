//
//  MockImageLoader.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 28/09/26.
//

import UIKit
@testable import NetworkLayer

final class MockImageLoader: ImageLoading {

    var image: UIImage?
    var loadImageCalled = false
    var cancelLoadCalled = false

    init(image: UIImage? = nil) {
        self.image = image
    }

    @discardableResult
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> UUID {
        loadImageCalled = true
        completion(image)
        return UUID()
    }

    func cancelLoad(for imageRequestID: UUID?) {
        cancelLoadCalled = true
    }
}
