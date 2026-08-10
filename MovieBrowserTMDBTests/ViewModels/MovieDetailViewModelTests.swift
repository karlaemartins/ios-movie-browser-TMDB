//
//  MovieDetailViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 20/07/26.
//

import XCTest
@testable import NetworkLayer

private enum TestError: Error {
    case someError
}

final class MovieDetailViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockStorage: MockFavoritesStorage!
    private var mockMovieService: MockMovieService!
    private var sut: MovieDetailViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockStorage = MockFavoritesStorage()
        mockMovieService = MockMovieService()
    }

    // MARK: - Tests Favorites
    
    //Verifica se a VM identifica corretamente um filme fav
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
    
    //Verifica se a VM identifica corretamente um filme que n está fav
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
    
    // Verifica se a VM salva o filme ao favoritar um filme que ainda n é fav
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
    
    // Verifica se a VM remove o filme ao desfavoritar um filme já fav
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
    
    
    // MARK: - Tests Fetch Movie Details
    
    // Verifica se a VM solicita os dets do filme ao MovieService
    func testFetchMovieDetails_WhenSucess_CallsMovieService() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService)
        
        //Act
        sut.fetchMovieDetails(completion: {})
        
        //Assert
        XCTAssertTrue(mockMovieService.fetchMovieDetailsCalled)
        XCTAssertEqual(mockMovieService.receivedMovieID, movie.id)
    }
    
    // Verifica se a VM atualiza os dets do filme quando a requisição é ok
    func testFetchMovieDetailsUpdatesMovieDetailOnSuccess() {

        //Arrange
        let movie = MovieFixture.makeMovie()
        let movieDetail = MovieFixture.makeMovieDetail()

        mockMovieService.result = .success(movieDetail)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        //Act
        sut.fetchMovieDetails(completion: {})

        //Assert
        XCTAssertEqual(sut.movieDetail, movieDetail)
    }
    
    // Verifica se a VM mantém os dets vazios quando a requisição falha
    func testFetchMovieDetailsDoesNotUpdateMovieDetailOnFailure() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        mockMovieService.result = .failure(TestError.someError)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        //Act
        sut.fetchMovieDetails(completion: {})

        //Assert
        XCTAssertNil(sut.movieDetail)
    }
    
    // Verifica se a VM executa o completion ao finalizar a busca dos dets
    func testFetchMovieDetailsCallsCompletion() {

        //Arrange
        let movie = MovieFixture.makeMovie()
        let movieDetail = MovieFixture.makeMovieDetail()

        mockMovieService.result = .success(movieDetail)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        let expectation = expectation(description: "Completion should be called")

        //Act
        sut.fetchMovieDetails {
            expectation.fulfill()
        }

        //Assert
        wait(for: [expectation], timeout: 1.0)
    }

}
