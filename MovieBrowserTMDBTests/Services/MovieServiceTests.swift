//
//  MovieServiceTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 16/09/26.
//

import XCTest
@testable import NetworkLayer

final class MovieServiceTests: XCTestCase {

    // MARK: - Properties
    private var mockNetwork: MockNetworkDispatch!
    private var sut: MovieService!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkDispatch()
        sut = MovieService(network: mockNetwork)
    }

    // MARK: - Tests
    func testFetchGenresCallsNetworkDispatch() {
        
        // Act
        sut.fetchGenres(completion: { result in
        })

        // Assert
        XCTAssertTrue(mockNetwork.dispatchCalled)
    }
    
    
    func testFetchGenresUsesGenresEndpoint() {
        // Act
        sut.fetchGenres(completion: { result in
        })

        // Assert
        guard let endpoint = mockNetwork.receivedEndpoint as? Services else {
            XCTFail("O endpoint recebido não é um Services")
            return
        }

        switch endpoint {
        case .genres:
            break

        default:
            XCTFail("O MovieService não enviou o endpoint de gêneros")
        }
    }
    
    func testFetchGenresReturnsResultFromNetwork() {
        // Arrange
        let genres = [
            Genre(id: 14, name: "Fantasia")
        ]

        let expectedResult = GenreResponse(genres: genres)
        mockNetwork.result = Result<GenreResponse, NetworkError>.success(expectedResult)

        // Act
        var receivedResult: Result<GenreResponse, NetworkError>?

        sut.fetchGenres(completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .success(let response) = receivedResult {
            XCTAssertEqual(response.genres?.first?.id, 14)
            XCTAssertEqual(response.genres?.first?.name, "Fantasia")
        } else {
            XCTFail("Era esperado um resultado de sucesso")
        }
    }
    
    
    func testFetchGenresReturnsErrorFromNetwork() {
        // Arrange
        mockNetwork.result = Result<GenreResponse, NetworkError>.failure(.noData)

        // Act
        var receivedResult: Result<GenreResponse, NetworkError>?

        sut.fetchGenres(completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .failure(let error) = receivedResult {
            if case .noData = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Era esperado o erro .noData")
            }
        } else {
            XCTFail("Era esperado um resultado de falha")
        }
    }
    
    
    func testFetchPopularMoviesReturnsResultFromNetwork() {
        // Arrange
        let movies = [
            MovieFixture.makeMovie(id: 1),
            MovieFixture.makeMovie(id: 2)
        ]

        let expectedResult = MovieResponse(results: movies)
        mockNetwork.result = Result<MovieResponse, NetworkError>.success(expectedResult)

        // Act
        var receivedResult: Result<MovieResponse, NetworkError>?

        sut.fetchPopularMovies(completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .success(let response) = receivedResult {
            XCTAssertEqual(response.results.count, 2)
            XCTAssertEqual(response.results[0].id, 1)
            XCTAssertEqual(response.results[1].id, 2)
        } else {
            XCTFail("Era esperado um resultado de sucesso")
        }
    }
    
    func testFetchPopularMoviesUsesPopularMoviesEndpoint() {
        // Act
        sut.fetchPopularMovies(page: 3, completion: { result in
        })

        // Assert
        guard let endpoint = mockNetwork.receivedEndpoint as? Services else {
            XCTFail("O endpoint recebido não é um Services")
            return
        }

        switch endpoint {
        case .popularMovies:
            break

        default:
            XCTFail("O MovieService não enviou o endpoint de filmes populares")
        }
    }
    
    func testFetchPopularMoviesPassesCorrectPageToEndpoint() {
        // Act
        sut.fetchPopularMovies(page: 3, completion: { result in
        })

        // Assert
        guard let endpoint = mockNetwork.receivedEndpoint as? Services else {
            XCTFail("O endpoint recebido não é um Services")
            return
        }

        switch endpoint {
        case .popularMovies(_, _, let page):
            XCTAssertEqual(page, 3)

        default:
            XCTFail("O MovieService não enviou o endpoint de filmes populares")
        }
    }
    
    
    func testFetchPopularMoviesReturnsErrorFromNetwork() {
        // Arrange
        mockNetwork.result = Result<MovieResponse, NetworkError>.failure(.noData)

        // Act
        var receivedResult: Result<MovieResponse, NetworkError>?

        sut.fetchPopularMovies(page: 1, completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .failure(let error) = receivedResult {
            if case .noData = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Era esperado o erro .noData")
            }
        } else {
            XCTFail("Era esperado um resultado de falha")
        }
    }
    
    
    func testFetchMovieDetailsUsesMovieDetailsEndpoint() {
        // Act
        sut.fetchMovieDetails(movieID: 42, completion: { result in
        })

        // Assert
        guard let endpoint = mockNetwork.receivedEndpoint as? Services else {
            XCTFail("O endpoint recebido não é um Services")
            return
        }

        switch endpoint {
        case .movieDetails(let id, _, _):
            XCTAssertEqual(id, 42)

        default:
            XCTFail("O MovieService não enviou o endpoint de detalhes do filme")
        }
    }
    
    
    func testFetchMovieDetailsReturnsResultFromNetwork() {
        // Arrange
        let expectedMovieDetail = MovieFixture.makeMovieDetail(
            id: 42,
            voteAverage: 8.5,
            runtime: 152,
            originalLanguage: "en"
        )

        mockNetwork.result = Result<MovieDetail, NetworkError>.success(expectedMovieDetail)

        // Act
        var receivedResult: Result<MovieDetail, NetworkError>?

        sut.fetchMovieDetails(movieID: 42, completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .success(let movieDetail) = receivedResult {
            XCTAssertEqual(movieDetail.id, 42)
            XCTAssertEqual(movieDetail.voteAverage, 8.5)
            XCTAssertEqual(movieDetail.runtime, 152)
            XCTAssertEqual(movieDetail.originalLanguage, "en")
        } else {
            XCTFail("Era esperado um resultado de sucesso")
        }
    }
    
    
    func testFetchMovieDetailsReturnsErrorFromNetwork() {
        // Arrange
        mockNetwork.result = Result<MovieDetail, NetworkError>.failure(.noData)

        // Act
        var receivedResult: Result<MovieDetail, NetworkError>?

        sut.fetchMovieDetails(movieID: 42, completion: { result in
            receivedResult = result
        })

        // Assert
        XCTAssertNotNil(receivedResult)

        if case .failure(let error) = receivedResult {
            if case .noData = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Era esperado o erro .noData")
            }
        } else {
            XCTFail("Era esperado um resultado de falha")
        }
    }
}
