//
//  Services.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 08/09/25.
//

import Foundation

enum Services {

    case genres(apiKey: String, language: String)
    case popularMovies(apiKey: String, language: String, page: Int)
    case movieDetails(id: Int, apiKey: String, language: String)
}

extension Services: EndPoint {
    
    var scheme: String { "https" }
    var host: String { "api.themoviedb.org" }
    var path: String {
        switch self {
        case .genres:
            return "/3/genre/movie/list"
        case .popularMovies:
            return "/3/movie/popular"
        case .movieDetails(let id, _, _):
            return "/3/movie/\(id)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var query: [String: String]? {
        switch self {
        case .genres(let apiKey, let language):
            return [
                "api_key": apiKey,
                "language": language
            ]
        case .popularMovies(let apiKey, let language, let page):
            return [
                "api_key": apiKey,
                "language": language,
                "page": "\(page)"
            ]
        case .movieDetails(_, let apiKey, let language):
            return [
                "api_key": apiKey,
                "language": language
            ]
        }
    }

}

