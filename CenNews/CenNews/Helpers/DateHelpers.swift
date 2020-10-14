//
//  DateHelpers.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import Foundation

extension DateFormatter {
    public static var `default`: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 7 * 60 * 60)
        formatter.locale = Locale(identifier: "th_TH")
        return formatter
    }
    
    public static var publishedDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 7 * 60 * 60)
        formatter.locale = Locale(identifier: "th_TH")
        return formatter
    }
}

extension Date {
    public init?(dateString: String?) {
        guard let dateString = dateString,
              let date = DateFormatter.default.date(from: dateString) else { return nil }
        self.init(timeInterval: 0, since: date)
    }
    
    func toDateString(withFormat format: String) -> String {
        let formatter = DateFormatter.default
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDateString(withFormat format: DateFormatter) -> String {
        return format.string(from: self)
    }
}
