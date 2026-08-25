//
//  ImageLoading.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 24/08/26.
//

import UIKit

protocol ImageLoading {
    @discardableResult
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> UUID

    func cancelLoad(for imageRequestID: UUID?)
}
