# CPSC 411 Final Project — Milestone 1: UIKit User Interface

## Application Name

**Mileage Pay** (repository: `travel-reimbursement-tracker`)

## Project Description

Mileage Pay helps employees get paid back for driving their own car for work. For each business trip, the employee records where they went, and the app works out the distance driven. In Milestone 3 that distance will come from the phone's GPS. The app then combines the distance with the vehicle's fuel economy (MPG) and the gas price to calculate the reimbursement: `(miles ÷ MPG) × gas price`. Employees can see all their trips, check how much money they are still owed, and submit pending trips for reimbursement. It replaces paper mileage logs and guesswork, so employees are paid back fairly and accurately for the gas they spend on company business.

## Implementation Approach

All screens are built **programmatically with UIKit** (Option B). There is no storyboard; the window and `UINavigationController` are created in `SceneDelegate`. Every screen uses **Auto Layout** with anchors and the safe area, and **UIStackView** is used to arrange forms, rows, and cards. Trips are hard-coded sample data kept in memory (`TripStore`).

## Screen List

| # | Screen | Purpose |
|---|--------|---------|
| 1 | `HomeViewController` | Entry point. Shows a summary: amount still owed, number of trips, total miles, and total reimbursement. Buttons start a new trip or open the trip list. |
| 2 | `TripListViewController` | `UITableView` of all trips with a custom cell (purpose, route, date, miles, amount, status badge). A segmented control filters by status (All / Pending / Submitted / Paid). The **+** button adds a trip, and tapping a row opens its details. |
| 3 | `TripDetailViewController` | Shows one trip: amount, status, route, date, the step-by-step reimbursement calculation, and notes. A placeholder marks where the GPS route map will go. **Edit** opens the edit form, and **Submit for Reimbursement** marks a pending trip as submitted. |
| 4 | `AddEditTripViewController` | Form for adding a new trip or editing an existing one: purpose, from/to, date picker, GPS switch (placeholder), distance, gas price, MPG slider, status, and notes. Shows a live reimbursement estimate while you type. |

## Screen Navigation Diagram

```
                    +------------------+
                    |       Home       |
                    +------------------+
                      |              |
     "View All Trips" |              | "Start New Trip"
                      v              v
         +-----------------+  "+"  +------------------+
         |    Trip List    |------>|     Add Trip     |
         +-----------------+       +------------------+
                  |
          tap row v
         +-----------------+ "Edit" +------------------+
         |   Trip Detail   |------->|    Edit Trip     |
         +-----------------+        +------------------+

   (Add Trip and Edit Trip are the same screen: AddEditTripViewController)
```

All screens are pushed onto one `UINavigationController`, so the back button returns to the previous screen. Saving a trip on the Add/Edit screen goes back automatically.

## Screenshots

_Add one screenshot of each screen from the iOS Simulator:_

1. Home
2. Trip List
3. Trip Detail
4. Add Trip / Edit Trip

## Not Yet Implemented (planned for later milestones)

- Real GPS distance tracking (Core Location) and a route map
- Live gas prices
- Saving trips permanently
- SwiftUI version of selected screens (Milestone 2)
