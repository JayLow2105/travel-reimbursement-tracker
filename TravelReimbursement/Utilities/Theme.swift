//
//  Theme.swift
//  TravelReimbursement
//
//  Shared colors, fonts, and spacing so every screen looks consistent.
//

import UIKit

enum Theme {

    // MARK: - Colors

    enum Colors {
        static let primary = UIColor.systemTeal
        static let background = UIColor.systemGroupedBackground
        static let card = UIColor.secondarySystemGroupedBackground
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let money = UIColor.systemGreen
    }

    // MARK: - Fonts

    enum Fonts {
        static let largeValue = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title = UIFont.preferredFont(forTextStyle: .headline)
        static let body = UIFont.preferredFont(forTextStyle: .body)
        static let caption = UIFont.preferredFont(forTextStyle: .subheadline)
    }

    // MARK: - Spacing

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    static let cornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 50

    // MARK: - Reusable button styles

    /// Large filled button used for the main action on a screen.
    @MainActor
    static func makePrimaryButton(title: String, systemImage: String? = nil) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = Colors.primary
        config.cornerStyle = .large
        if let systemImage = systemImage {
            config.image = UIImage(systemName: systemImage)
            config.imagePadding = Spacing.small
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Priority 999 so the button can still be hidden inside a stack view.
        let height = button.heightAnchor.constraint(equalToConstant: buttonHeight)
        height.priority = UILayoutPriority(999)
        height.isActive = true
        return button
    }

    /// Outlined button used for secondary actions.
    @MainActor
    static func makeSecondaryButton(title: String, systemImage: String? = nil) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.baseForegroundColor = Colors.primary
        config.baseBackgroundColor = Colors.primary
        config.cornerStyle = .large
        if let systemImage = systemImage {
            config.image = UIImage(systemName: systemImage)
            config.imagePadding = Spacing.small
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Priority 999 so the button can still be hidden inside a stack view.
        let height = button.heightAnchor.constraint(equalToConstant: buttonHeight)
        height.priority = UILayoutPriority(999)
        height.isActive = true
        return button
    }
}
