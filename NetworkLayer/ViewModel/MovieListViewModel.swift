//
//  MovieListViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 07/07/25.
//

import Foundation

class MovieListViewModel {

    private let movieService: MovieServiceProtocol
    
    var genres: [Genre] = []
    var popularMovies: [Movie] = []
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }

    //Gêneros
    func fetchGenres(completion: @escaping () -> Void) {
        movieService.fetchGenres { [weak self] result in
            switch result {
            case .success(let response):
                self?.genres = response.genres ?? []
                completion()

            case .failure(let error):
                print("Erro ao buscar gêneros: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    //Filmes Populares
    func fetchPopularMovies(page: Int = 1, completion: @escaping () -> Void) {
        movieService.fetchPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.popularMovies = response.results
                completion()

            case .failure(let error):
                print("Erro ao buscar filmes: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    //generos e filmes populares
    func fetchData(completion: @escaping () -> Void) {
        //busca dos generos
        fetchGenres { [weak self] in
            //busca dos filmes populares
            self?.fetchPopularMovies {
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
