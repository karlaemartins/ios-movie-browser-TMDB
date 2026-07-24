//
//  MovieDetailViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 20/07/26.
//

import XCTest
@testable import NetworkLayer

final class MovieDetailViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockStorage: MockFavoritesStorage!
    private var sut: MovieDetailViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockStorage = MockFavoritesStorage()
    }

    // MARK: - Tests
    
    func testIsFavoriteReturnsTrueWhenMovieIsFavorite() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = [movie]

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Assert
        XCTAssertTrue(sut.isFavorite)
    }
    
    func testIsFavoriteReturnsFalseWhenMovieIsNotFavorite() {
        
        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = []

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Assert
        XCTAssertFalse(sut.isFavorite)
        
    }
    
    func testToggleFavoriteSavesMovieWhenMovieIsNotFavorite() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Act
        sut.toggleFavorite()

        //Assert
        XCTAssertTrue(mockStorage.saveCalled)
        XCTAssertTrue(mockStorage.isFavorite(movie))
    }
    
    func testToggleFavoriteRemovesMovieWhenMovieIsFavorite() {
        
        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = [movie]

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )
        
        //Act
        sut.toggleFavorite()
        
        //Assert
        XCTAssertTrue(mockStorage.removeCalled)
        XCTAssertFalse(mockStorage.isFavorite(movie))
    }

}
