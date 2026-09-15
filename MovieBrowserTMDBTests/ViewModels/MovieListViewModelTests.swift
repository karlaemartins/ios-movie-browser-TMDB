//
//  MovieListViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 15/09/26.
//

import XCTest
@testable import NetworkLayer

final class MovieListViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockMovieService: MockMovieService!
    private var sut: MovieListViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockMovieService = MockMovieService()
        sut = MovieListViewModel(movieService: mockMovieService)
    }

    // MARK: - Tests

    func testFetchGenresUpdatesGenresOnSuccess() {
        // Arrange
        let genres = [
            Genre(id: 14, name: "Fantasia"),
            Genre(id: 12, name: "Aventura")
        ]

        let response = GenreResponse(genres: genres)
        mockMovieService.genresResult = .success(response)

        // Act
        var completionCalled = false

        sut.fetchGenres {
            completionCalled = true
        }

        // Assert
        XCTAssertEqual(sut.genres.count, 2)
        XCTAssertEqual(sut.genres[0].id, genres[0].id)
        XCTAssertEqual(sut.genres[1].id, genres[1].id)
        XCTAssertTrue(completionCalled)
    }
    
    
    func testFetchGenresCallsCompletionOnFailure() {
        // Arrange
        mockMovieService.genresResult = .failure(.noData)

        var completionCalled = false

        // Act
        sut.fetchGenres {
            completionCalled = true
        }

        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertTrue(sut.genres.isEmpty)
    }
    
    
    func testFetchPopularMoviesUpdatesMoviesOnSuccess() {
        // Arrange
        let movies = [
            MovieFixture.makeMovie(id: 1),
            MovieFixture.makeMovie(id: 2)
        ]

        let response = MovieResponse(results: movies)
        mockMovieService.popularMoviesResult = .success(response)

        // Act
        var completionCalled = false

        sut.fetchPopularMovies {
            completionCalled = true
        }

        // Assert
        XCTAssertEqual(sut.popularMovies.count, 2)
        XCTAssertEqual(sut.popularMovies[0].id, movies[0].id)
        XCTAssertEqual(sut.popularMovies[1].id, movies[1].id)
        XCTAssertTrue(completionCalled)
    }
    
    
    func testFetchPopularMoviesPassesCorrectPageToService() {
        // Arrange
        let page = 3
        mockMovieService.popularMoviesResult = .success(MovieResponse(results: []))

        // Act
        sut.fetchPopularMovies(page: page, completion: {})

        // Assert
        XCTAssertTrue(mockMovieService.fetchPopularMoviesCalled)
        XCTAssertEqual(mockMovieService.receivedPage, page)
    }
    
    
    func testFetchPopularMoviesCallsCompletionOnFailure() {
        // Arrange
        mockMovieService.popularMoviesResult = .failure(.noData)
        var completionCalled = false

        // Act
        sut.fetchPopularMovies {
            completionCalled = true
        }

        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertTrue(sut.popularMovies.isEmpty)
    }
    
    func testFetchDataCallsGenresAndPopularMovies() {
        // Arrange
        mockMovieService.genresResult = .success(GenreResponse(genres: []))
        mockMovieService.popularMoviesResult = .success(MovieResponse(results: []))
        var completionCalled = false

        // Act
        sut.fetchData {
            completionCalled = true
        }

        // Assert
        XCTAssertTrue(mockMovieService.fetchGenresCalled)
        XCTAssertTrue(mockMovieService.fetchPopularMoviesCalled)
        XCTAssertTrue(completionCalled)
    }
    
    func testGenreNamesReturnsMatchingGenreNames() {
        // Arrange
        let genres = [
            Genre(id: 14, name: "Fantasia"),
            Genre(id: 12, name: "Aventura"),
            Genre(id: 28, name: "Ação")
        ]

        sut.genres = genres

        let movie = MovieFixture.makeMovie(genreIDs: [14, 12])

        // Act
        let result = sut.genreNames(for: movie)

        // Assert
        XCTAssertEqual(result, ["Fantasia", "Aventura"])
    }
    
    
    func testGenreNamesReturnsEmptyWhenMovieHasNoGenreIDs() {
        // Arrange
        let movie = MovieFixture.makeMovie(genreIDs: nil)

        // Act
        let result = sut.genreNames(for: movie)

        // Assert
        XCTAssertTrue(result.isEmpty)
    }
    
    
    func testFetchGenresSetsEmptyArrayWhenResponseHasNoGenres() {
        // Arrange
        mockMovieService.genresResult = .success(GenreResponse(genres: nil))

        // Act
        sut.fetchGenres {}

        // Assert
        XCTAssertTrue(sut.genres.isEmpty)
    }
    
}
