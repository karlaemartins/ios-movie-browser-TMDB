//
//  MovieFavoritesViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 15/07/26.
//

import XCTest
@testable import NetworkLayer

final class MovieFavoritesViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var mockStorage: MockFavoritesStorage!
    private var sut: MovieFavoritesViewModel!
    
    // MARK: - Lifecycle
    override func setUp() {
            super.setUp()

            mockStorage = MockFavoritesStorage()
            sut = MovieFavoritesViewModel(favoritesStorage: mockStorage)
        }

    // MARK: - Tests
    func testLoadFavoritesUpdatesFavoriteMovies() {
        // Arrange
        let movie = MovieFixture.makeMovie()
        mockStorage.favoriteMovies = [movie]

        // Act
        sut.loadFavorites()
        
        // Assert
        XCTAssertEqual(sut.numberOfMovies, 1)
        XCTAssertEqual(sut.movie(at: 0).id, movie.id)

    }
    
    func testRemoveFavoriteRemovesMovie() {
        // Arrange
        let movie = MovieFixture.makeMovie()
        mockStorage.favoriteMovies = [movie]
        
        // Act
        sut.loadFavorites()
        sut.removeFavorite(at: 0)
        
        // Assert
        XCTAssertEqual(mockStorage.removedMovie?.id, movie.id)
        XCTAssertEqual(sut.numberOfMovies, 0)
        
    }
}
