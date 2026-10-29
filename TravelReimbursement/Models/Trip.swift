//
//  Trip.swift
//  TravelReimbursement
//
//  One business trip an employee drove and wants to be paid back for.
//

import Foundation

enum TripStatus: String, CaseIterable {
    case pending = "Pending"
    case submitted = "Submitted"
    case paid = "Paid"
}

struct Trip {
    let id: UUID
    var purpose: String
    var startLocation: String
    var endLocation: String
    var date: Date
    /// Distance driven in miles. In Milestone 3 this will come from GPS tracking.
    var distanceMiles: Double
    /// Gas price in dollars per gallon on the day of the trip.
    var gasPricePerGallon: Double
    /// Fuel economy of the employee's vehicle, in miles per gallon.
    var vehicleMPG: Double
    var notes: String
    var status: TripStatus

    init(id: UUID = UUID(),
         purpose: String,
         startLocation: String,
         endLocation: String,
         date: Date,
         distanceMiles: Double,
         gasPricePerGallon: Double,
         vehicleMPG: Double,
         notes: String = "",
         status: TripStatus = .pending) {
        self.id = id
        self.purpose = purpose
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.date = date
        self.distanceMiles = distanceMiles
        self.gasPricePerGallon = gasPricePerGallon
        self.vehicleMPG = vehicleMPG
        self.notes = notes
        self.status = status
    }

    /// Gallons of gas used for the trip.
    var gallonsUsed: Double {
        guard vehicleMPG > 0 else { return 0 }
        return distanceMiles / vehicleMPG
    }

    /// Amount the company pays back: gallons used x gas price.
    var reimbursementAmount: Double {
        Trip.reimbursement(miles: distanceMiles, mpg: vehicleMPG, gasPrice: gasPricePerGallon)
    }

    /// Shared formula so the Add/Edit screen can show a live estimate.
    static func reimbursement(miles: Double, mpg: Double, gasPrice: Double) -> Double {
        guard mpg > 0 else { return 0 }
        return (miles / mpg) * gasPrice
    }
}
