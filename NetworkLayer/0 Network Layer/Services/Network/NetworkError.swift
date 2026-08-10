//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 10/08/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case decodingError(Error)
    case underlying(Error)
}
