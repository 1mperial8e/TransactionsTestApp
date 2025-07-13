//
//  XCTestCase+Delay.swift
//  TransactionsTestTask
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import XCTest

extension XCTestCase {
    func delay(miliseconds: TimeInterval) async {
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        await fulfillment(of: [delayExpectation], timeout: miliseconds / 1000)
    }
}
