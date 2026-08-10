//
//  NetworkRequest.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 08/09/25.
//

import Foundation

protocol NetworkDispatch {
    func dispatch<T: Codable>(endPoint: EndPoint, tipo: T.Type, resposta: @escaping (Result<T, NetworkError>) -> Void)
}

public struct NetworkRequest: NetworkDispatch {
    public static let instance = NetworkRequest()
    
    func dispatch<T>(endPoint: EndPoint, tipo: T.Type, resposta: @escaping (Result<T, NetworkError>) -> Void) where T : Codable {
        
        guard var urlRequest = endPoint.request else {
            resposta(.failure(.invalidURL))
            return
        }
        
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endPoint.headers
        
        if !endPoint.body.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: endPoint.body)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            
            guard let httpResponse else {
                    resposta(.failure(.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    resposta(.failure(.httpError(statusCode: httpResponse.statusCode)))
                    return
                }
            
            if let error {
                resposta(.failure(.underlying(error)))
                return
            }

            guard let data else {
                resposta(.failure(.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                resposta(.success(decoded))
            } catch {
                resposta(.failure(.decodingError(error)))
            }
            
        }.resume()
    }
}
 
