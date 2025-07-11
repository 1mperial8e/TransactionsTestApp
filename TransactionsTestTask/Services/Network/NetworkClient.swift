//
//  NetworkClient.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

protocol NetworkClient {
    func perform<T: Decodable>(endpoint: Endpoint) async throws -> T
}

final class NetworkClientImpl: NetworkClient {
    private let session: URLSession = .shared

    func perform<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let request = try composeURLRequest(from: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unexpected
        }
        switch httpResponse.statusCode {
        case 200, 201, 204:
            break
        case NSURLErrorNotConnectedToInternet:
            throw NetworkError.noInternetConnection
        default:
            throw NetworkError.networkError(httpResponse.statusCode)
        }

        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.dataError
        }

        return decoded
    }

    private func composeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.host
        components.path = endpoint.path
        if let queryItems = endpoint.urlQueryParams {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw NetworkError.urlCreationFailed
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        if let body = endpoint.httpBody {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        request.allHTTPHeaderFields = endpoint.headers

        let contentTypeHeader = "Content-Type"
        if request.value(forHTTPHeaderField: contentTypeHeader) == nil {
            request.setValue("application/json", forHTTPHeaderField: contentTypeHeader)
        }
        return request
    }
}
