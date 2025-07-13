//
//  AnalyticsServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Stanislav Volskyi on 13.07.2025.
//

import Foundation
import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
    private var sut: AnalyticsServiceImpl!

    override func setUpWithError() throws {
        sut = .init()
    }

    func test_addEvents() {
        XCTAssertTrue(sut.getEvents().isEmpty)
        let eventDate = Date()
        sut.trackEvent(name: "test_name", parameters: ["test_param": "test_value"])
        let events = sut.getEvents()
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0].name, "test_name")
        XCTAssertEqual(events[0].parameters["test_param"], "test_value")
        XCTAssertTrue(Calendar.current.isDate(eventDate, inSameDayAs: events[0].date))
    }

    func test_getEvents_nameFilter() {
        XCTAssertTrue(sut.getEvents().isEmpty)
        // Name filter
        sut.trackEvent(name: "test_name1", parameters: ["test_param": "test_value"])
        sut.trackEvent(name: "test_name1", parameters: ["test_param": "test_value"])
        sut.trackEvent(name: "test_name2", parameters: ["test_param": "test_value"])
        let events = sut.getEvents(eventName: "test_name1")
        XCTAssertEqual(events.count, 2)
    }

    func test_getEvents_dateFilter() async {
        XCTAssertTrue(sut.getEvents().isEmpty)
        // Older event
        let startDate = Date().addingTimeInterval(100 / 1000)
        sut.trackEvent(name: "test_name1", parameters: ["test_param": "test_value"])
        await delay(miliseconds: 100)
        sut.trackEvent(name: "test_name2", parameters: ["test_param": "test_value"])
        sut.trackEvent(name: "test_name2", parameters: ["test_param": "test_value"])
        await delay(miliseconds: 100)
        let endDate = Date()
        // Newer event
        sut.trackEvent(name: "test_name3", parameters: ["test_param": "test_value"])
        let events = sut.getEvents(from: startDate, to: endDate)
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events[0].name, "test_name2")
        XCTAssertEqual(events[1].name, "test_name2")
    }
}
