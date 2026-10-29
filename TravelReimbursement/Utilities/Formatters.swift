//
//  Formatters.swift
//  TravelReimbursement
//
//  Helpers for showing money, miles, and dates the same way on every screen.
//

import Foundation

enum Formatters {

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()

    private static let milesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    /// 12.5 -> "$12.50"
    static func currency(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    /// 42.25 -> "42.3 mi"
    static func miles(_ value: Double) -> String {
        let number = milesFormatter.string(from: NSNumber(value: value)) ?? "0.0"
        return "\(number) mi"
    }

    /// Date -> "Oct 29, 2026"
    static func date(_ value: Date) -> String {
        dateFormatter.string(from: value)
    }
}
