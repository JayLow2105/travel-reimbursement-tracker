# Mileage Pay — Travel Reimbursement Tracker

CPSC 411 final project: an iOS app that tracks employee travel mileage and calculates gas reimbursement.

**Reimbursement = (miles driven ÷ vehicle MPG) × gas price per gallon**

## Milestone 1: UIKit User Interface

- Built **programmatically with UIKit**, with no storyboard
- **Auto Layout** with anchors and the safe area on every screen
- **UIStackView** for forms, rows, and cards
- **UITableView** with a custom cell for the trip list
- **UINavigationController** connecting all screens
- Hard-coded sample trips (in-memory `TripStore`)

See [docs/Milestone1.md](docs/Milestone1.md) for the project description, screen list, and navigation diagram.

## Screens

| Screen | File |
|--------|------|
| Home | `Controllers/HomeViewController.swift` |
| Trip List | `Controllers/TripListViewController.swift` |
| Trip Detail | `Controllers/TripDetailViewController.swift` |
| Add / Edit Trip | `Controllers/AddEditTripViewController.swift` |

## Project Structure

```
TravelReimbursement/
├── App/          AppDelegate, SceneDelegate (creates the window and navigation controller)
├── Controllers/  The four screens
├── Models/       Trip, TripStore (sample data)
├── Views/        Reusable views: cards, table cell, form field, detail row, status badge
└── Utilities/    Theme (colors, fonts, spacing, buttons), Formatters
```

## How to Run

1. Requires **Xcode 16 or later**.
2. Open `TravelReimbursement.xcodeproj`.
3. Pick an iPhone simulator and press **Run** (⌘R).

New `.swift` files added to the `TravelReimbursement` folder are picked up by Xcode automatically.
