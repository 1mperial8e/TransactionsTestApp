//
//  BitcoinRateResponse.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 11.07.2025.
//

import Foundation

struct BitcoinRateResponse {
    let value: Decimal

}

extension BitcoinRateResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }

    enum DataContainerCodingKeys: String, CodingKey {
        case btcUsd = "BTC-USD"
    }

    enum BtcUsdContainerCodingKeys: String, CodingKey {
        case value = "VALUE"
    }

    init(from decoder: any Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataContainerCodingKeys.self, forKey: .data)
        let btcContainer = try dataContainer.nestedContainer(keyedBy: BtcUsdContainerCodingKeys.self, forKey: .btcUsd)
        self.value = try btcContainer.decode(Decimal.self, forKey: .value)
    }
}
