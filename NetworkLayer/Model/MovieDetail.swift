//
//  MovieDetail.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 13/07/26.
//

import Foundation


struct MovieDetail: Codable {

    let id: Int
    let voteAverage: Double
    let runtime: Int?
    let originalLanguage: String

    enum CodingKeys: String, CodingKey {
        case id
        case runtime
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
    }
}
