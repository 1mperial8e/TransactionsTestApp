//
//  NetworkClientStub.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation
@testable import TransactionsTestTask

final class NetworkClientStub: NetworkClient {
    var stubbedJson: [String: Any]?

    func perform<T>(endpoint: any TransactionsTestTask.Endpoint) async throws -> T where T : Decodable {
        guard let stubbedJson else {
            throw NetworkError.dataError
        }
        let data = try JSONSerialization.data(withJSONObject: stubbedJson)
        return try JSONDecoder().decode(T.self, from: data)
    }

}
