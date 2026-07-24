//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 08/09/25.
//

import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [String: String]? { get }
    var headers: [String: String] { get }
    var body: [String: Any] { get }
}

//extensão que gera a URL aut. a partir das propriedades do protocolo acima.
extension EndPoint {
    var headers: [String: String] { [:] }
    var body: [String: Any] { [:] }

    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components
    }

    var request: URLRequest? {
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}
