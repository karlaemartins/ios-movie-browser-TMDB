# iOS Movie Browser - Projeto de Estudo

Aplicativo desenvolvido em **UIKit** para exibição de filmes populares utilizando a API do **The Movie Database (TMDB)**. O projeto foi criado com foco no estudo de arquitetura, consumo de APIs REST e construção de uma **Network Layer reutilizável**, utilizando MVVM e Coordinator.

## O que o app faz

- Lista filmes populares
- Exibe o pôster do filme
- Mostra gêneros e ano de lançamento
- Exibe uma tela de detalhes com a sinopse
- Navega entre telas utilizando Coordinator e UINavigationController

## Arquitetura

O projeto foi estruturado utilizando **MVVM** combinado com o padrão **Coordinator**, separando responsabilidades entre interface, lógica de apresentação, navegação e comunicação com a API.

### Fluxo de dados

View → ViewModel → Network Layer → API

### Fluxo de navegação

Coordinator → UINavigationController → ViewController

## Decisões importantes

- UIKit programático (sem Storyboard)
- Arquitetura MVVM
- Coordinator Pattern
- Network Layer reutilizável
- Consumo de API REST utilizando URLSession
- Decodificação de JSON utilizando Codable
- Organização por camadas (View, ViewModel, Model, Network e Coordinator)

## Estrutura do projeto

### View

- MovieListViewController
- MovieDetailViewController
- MovieTableViewCell

### ViewModel

- MovieListViewModel

### Model

- Movie
- Genre
- MovieResponse
- GenreResponse

### Network Layer

- EndPoint
- HTTPMethod
- NetworkRequest
- Services

### Coordinator

- AppCoordinator
- HomeCoordinator

## Conceitos praticados

- Swift
- UIKit
- URLSession
- Codable
- MVVM
- Coordinator Pattern
- Auto Layout
- UITableView
- Consumo de API REST
- Decodificação de JSON

## API utilizada

Este projeto utiliza a API pública do **The Movie Database (TMDB)**.

https://developer.themoviedb.org
