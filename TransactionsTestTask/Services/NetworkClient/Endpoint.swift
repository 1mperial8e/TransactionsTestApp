//
//  Endpoint.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var scheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var httpBody: [String: Any]? { get }
    var urlQueryParams: [URLQueryItem]? { get }
    var headers: [String: String] { get }
}

