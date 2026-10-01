//
//  MovieListViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 07/07/25.
//

import Foundation

class MovieListViewModel {

    private let movieService: MovieServiceProtocol
    
    private(set) var genres: [Genre] = []
    private(set) var popularMovies: [Movie] = []
    private(set) var state: ViewState = .idle
    
    var numberOfMovies: Int {
        popularMovies.count
    }

    func movie(at index: Int) -> Movie {
        popularMovies[index]
    }
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }

    //Gêneros
    func fetchGenres(completion: @escaping (Result<Void, NetworkError>) -> Void){
        movieService.fetchGenres { [weak self] result in
            switch result {
            case .success(let response):
                self?.genres = response.genres ?? []
                completion(.success(()))

            case .failure(let error):
                print("Erro ao buscar gêneros: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //Filmes Populares
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<Void, NetworkError>) -> Void){
        movieService.fetchPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.popularMovies = response.results
                completion(.success(()))

            case .failure(let error):
                print("Erro ao buscar filmes: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    //generos e filmes populares
    func fetchData(completion: @escaping () -> Void) {
        state = .loading

        fetchGenres { [weak self] result in
            switch result {
            case .success:
                self?.fetchPopularMovies { result in
                    switch result {
                    case .success:
                        self?.state = .loaded
                        completion()
                        
                    case .failure:
                        self?.state = .error("Não foi possível carregar os filmes.")
                        completion()
                    }
                }

            case .failure:
                self?.state = .error("Não foi possível carregar os gêneros.")
                completion()
            }
        }
    }
    
    //função para pegar nomes de generos de um filme
    func genreNames(for movie: Movie) -> [String] {
        guard let ids = movie.genreIDs else { return [] }
        return genres.filter { ids.contains($0.id ?? -1) }.compactMap { $0.name }
    }
}
