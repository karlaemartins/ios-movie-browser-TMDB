//
//  MovieDetailViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 13/07/26.
//

import Foundation

final class MovieDetailViewModel {

    private let apiKey = Secrets.apiKey
    private let language = "pt-BR"

    private(set) var movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }
}
