//
//  NetworkError.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

enum NetworkError: Error {
    case urlCreationFailed
    case noInternetConnection
    case unexpected
    case dataError
    case networkError(Int)
}
