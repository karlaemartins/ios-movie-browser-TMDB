//
//  ViewState.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 01/10/26.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
