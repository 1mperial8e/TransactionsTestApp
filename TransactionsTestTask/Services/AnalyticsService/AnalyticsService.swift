//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {
    func trackEvent(name: String, parameters: [String: String])
    func getEvents(from startDate: Date?, to endDate: Date?, eventName: String?) -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl {
    
    private var events: [AnalyticsEvent] = []
}

extension AnalyticsServiceImpl: AnalyticsService {
    
    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: .now
        )
        
        events.append(event)
    }

    func getEvents(from startDate: Date? = nil, to endDate: Date? = nil, eventName: String? = nil) -> [AnalyticsEvent] {
        return events
            .filter {
                var result = true
                if let startDate = startDate {
                    result = result && $0.date >= startDate
                }
                if let endDate = endDate {
                    result = result && $0.date <= endDate
                }
                if let eventName = eventName {
                    result = result && $0.name == eventName
                }
                return result
            }
    }

}
