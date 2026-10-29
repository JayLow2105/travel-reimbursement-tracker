//
//  TripStore.swift
//  TravelReimbursement
//
//  Keeps the list of trips in memory. For Milestone 1 it is filled with
//  hard-coded sample data; permanent storage comes in a later milestone.
//

import Foundation

final class TripStore {

    static let shared = TripStore()

    /// Default values used when the employee starts a new trip.
    var defaultGasPrice: Double = 4.89
    var defaultVehicleMPG: Double = 28

    private(set) var trips: [Trip]

    private init() {
        trips = TripStore.makeSampleTrips()
    }

    // MARK: - Summary values for the Home screen

    var totalMiles: Double {
        trips.reduce(0) { $0 + $1.distanceMiles }
    }

    var totalReimbursement: Double {
        trips.reduce(0) { $0 + $1.reimbursementAmount }
    }

    var amountOwed: Double {
        trips.filter { $0.status != .paid }.reduce(0) { $0 + $1.reimbursementAmount }
    }

    // MARK: - Reading and changing trips

    func trips(with status: TripStatus?) -> [Trip] {
        guard let status = status else { return trips }
        return trips.filter { $0.status == status }
    }

    func trip(withID id: UUID) -> Trip? {
        trips.first { $0.id == id }
    }

    /// Adds a new trip, or replaces the existing trip that has the same id.
    func save(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        } else {
            trips.insert(trip, at: 0)
        }
    }

    // MARK: - Sample data

    private static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }

    private static func makeSampleTrips() -> [Trip] {
        [
            Trip(purpose: "Client meeting - Irvine",
                 startLocation: "Fountain Valley Office",
                 endLocation: "Irvine Spectrum",
                 date: daysAgo(1),
                 distanceMiles: 14.2,
                 gasPricePerGallon: 4.89,
                 vehicleMPG: 28,
                 notes: "Quarterly review with client.",
                 status: .pending),
            Trip(purpose: "Supplier visit",
                 startLocation: "Fountain Valley Office",
                 endLocation: "Ontario Warehouse",
                 date: daysAgo(3),
                 distanceMiles: 46.8,
                 gasPricePerGallon: 4.95,
                 vehicleMPG: 28,
                 notes: "Inspected incoming shipment.",
                 status: .submitted),
            Trip(purpose: "Trade show",
                 startLocation: "Fountain Valley Office",
                 endLocation: "Anaheim Convention Center",
                 date: daysAgo(8),
                 distanceMiles: 12.6,
                 gasPricePerGallon: 4.79,
                 vehicleMPG: 30,
                 status: .paid),
            Trip(purpose: "Training session",
                 startLocation: "Home",
                 endLocation: "Los Angeles Downtown",
                 date: daysAgo(12),
                 distanceMiles: 38.4,
                 gasPricePerGallon: 4.99,
                 vehicleMPG: 25,
                 notes: "Full-day software training.",
                 status: .paid),
            Trip(purpose: "Bank deposit run",
                 startLocation: "Fountain Valley Office",
                 endLocation: "Huntington Beach Branch",
                 date: daysAgo(15),
                 distanceMiles: 6.3,
                 gasPricePerGallon: 4.85,
                 vehicleMPG: 28,
                 status: .pending)
        ]
    }
}
