//
//  BitcoinEndpoint.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

// https://api.coindesk.com/v1/bpi/currentprice.json didn't work, so found another API on coindesk

enum BitcoinEndpoint {
    case currentRate
}

extension BitcoinEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        return .GET
    }
    var host: String { "data-api.coindesk.com" }
    
    var scheme: HTTPScheme { .https }

    var path: String {
        switch self {
        case .currentRate:
            return "/index/cc/v1/latest/tick"
        }
    }

    var httpBody: [String : Any]? { nil }

    var urlQueryParams: [URLQueryItem]? {
        switch self {
        case .currentRate:
            return [
                .init(name: "market", value: "cadli"),
                .init(name: "instruments", value: "BTC-USD"),
                .init(name: "apply_mapping", value: "true")
            ]
        }
    }

    /*
        Just for demo purpose.
        It's unsecure to store API keys anywhere in the code or resources.
        Ideally such things should not be required when communicating with BE.
     */
    var headers: [String : String] {
        ["x-api-key": "0325daa38ecafcd7ee3ff6f5e9e4baec1f319d13139a86392777d1ed8d0d3179"]
    }
}
