//
//  MovieFavoritesViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 15/07/26.
//

import XCTest
@testable import NetworkLayer

final class MovieFavoritesViewModelTests: XCTestCase {

    func testLoadFavoritesUpdatesFavoriteMovies() {
        // Arrange
        let mockStorage = MockFavoritesStorage()
        let sut = MovieFavoritesViewModel(favoritesStorage: mockStorage)
        
        let movie = Movie(
            id: 1,
            title: "Harry Potter",
            releaseDate: "2001-11-16",
            genreIDs: [14, 12],
            posterPath: "/poster.jpg",
            overview: "Um jovem descobre que é um bruxo.")
        
        mockStorage.favoriteMovies = [movie]

        // Act
        sut.loadFavorites()
        
        // Assert
        XCTAssertEqual(sut.numberOfMovies, 1)
        XCTAssertEqual(sut.movie(at: 0).title, "Harry Potter")

    }
    
    func testRemoveFavoriteRemovesMovie() {
        //Arrange
        let mockStorage = MockFavoritesStorage()
        let sut = MovieFavoritesViewModel(favoritesStorage: mockStorage)

        let movie = Movie(
            id: 1,
            title: "Harry Potter",
            releaseDate: "2001-11-16",
            genreIDs: [14, 12],
            posterPath: "/poster.jpg",
            overview: "Um jovem descobre que é um bruxo.")

        mockStorage.favoriteMovies = [movie]

        sut.loadFavorites()
        
        //Act
        sut.removeFavorite(at: 0)
        
        //Assert
        XCTAssertTrue(mockStorage.removeCalled)
        XCTAssertEqual(sut.numberOfMovies, 0)
        
    }
}
