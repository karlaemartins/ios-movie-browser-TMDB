//
//  MovieFixture.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 21/07/26.
//

import Foundation
@testable import NetworkLayer

enum MovieFixture {

    static func makeMovie(
        id: Int = 1,
        title: String = "Harry Potter",
        releaseDate: String? = "2001-11-16",
        genreIDs: [Int] = [14, 12],
        posterPath: String? = "/poster.jpg",
        overview: String? = "Um jovem descobre que é um bruxo."
    ) -> Movie {

        Movie(
            id: id,
            title: title,
            releaseDate: releaseDate,
            genreIDs: genreIDs,
            posterPath: posterPath,
            overview: overview
        )
    }
}
