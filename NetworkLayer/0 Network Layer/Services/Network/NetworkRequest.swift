//
//  NetworkRequest.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 08/09/25.
//

import Foundation

protocol NetworkDispatch {
    func dispatch<T: Codable>(endPoint: EndPoint, tipo: T.Type, resposta: @escaping (T?, HTTPURLResponse?, Error?) -> Void)
}

public struct NetworkRequest: NetworkDispatch {
    public static let instance = NetworkRequest()
    
    func dispatch<T>(endPoint: EndPoint, tipo: T.Type, resposta: @escaping (T?, HTTPURLResponse?, Error?) -> Void) where T : Codable {
        
        guard var urlRequest = endPoint.request else { return }
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endPoint.headers
        
        if !endPoint.body.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: endPoint.body)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            
            guard let data = data else {
                resposta(nil, httpResponse, error)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                resposta(decoded, httpResponse, nil)
            } catch {
                resposta(nil, httpResponse, error)
            }
            
        }.resume()
    }
}
 
