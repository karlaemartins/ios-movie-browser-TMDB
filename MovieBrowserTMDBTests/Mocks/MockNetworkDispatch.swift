//
//  MockNetworkDispatch.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 16/09/26.
//

import Foundation
@testable import NetworkLayer

final class MockNetworkDispatch: NetworkDispatch {

    var dispatchCalled = false
    var receivedEndpoint: EndPoint?
    var receivedType: Any.Type?

    var result: Any?

    func dispatch<T: Codable>(
        endPoint: EndPoint,
        tipo: T.Type,
        resposta: @escaping (Result<T, NetworkError>) -> Void
    ) {
        dispatchCalled = true
        receivedEndpoint = endPoint
        receivedType = tipo

        if let result = result as? Result<T, NetworkError> {
            resposta(result)
        }
    }
}
