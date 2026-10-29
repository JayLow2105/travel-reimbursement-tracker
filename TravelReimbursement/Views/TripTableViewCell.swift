//
//  TripTableViewCell.swift
//  TravelReimbursement
//
//  Custom table view cell for the Trip List screen.
//
//  Layout:
//  [car icon]  Purpose ................ $12.34
//              Start -> End             [Status]
//              Date - 14.2 mi
//

import UIKit

final class TripTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TripTableViewCell"

    private let iconView = UIImageView(image: UIImage(systemName: "car.fill"))
    private let purposeLabel = UILabel()
    private let routeLabel = UILabel()
    private let infoLabel = UILabel()
    private let amountLabel = UILabel()
    private let statusBadge = StatusBadgeLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with trip: Trip) {
        purposeLabel.text = trip.purpose
        routeLabel.text = "\(trip.startLocation) → \(trip.endLocation)"
        infoLabel.text = "\(Formatters.date(trip.date)) • \(Formatters.miles(trip.distanceMiles))"
        amountLabel.text = Formatters.currency(trip.reimbursementAmount)
        statusBadge.configure(with: trip.status)
    }

    private func setUpViews() {
        accessoryType = .disclosureIndicator

        iconView.tintColor = Theme.Colors.primary
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        purposeLabel.font = Theme.Fonts.title
        routeLabel.font = Theme.Fonts.caption
        routeLabel.textColor = Theme.Colors.secondaryText
        infoLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        infoLabel.textColor = Theme.Colors.secondaryText

        amountLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        amountLabel.textColor = Theme.Colors.money
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Left column: text about the trip.
        let textStack = UIStackView(arrangedSubviews: [purposeLabel, routeLabel, infoLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        // Right column: amount and status badge.
        let rightStack = UIStackView(arrangedSubviews: [amountLabel, statusBadge])
        rightStack.axis = .vertical
        rightStack.alignment = .trailing
        rightStack.spacing = 6

        // Whole row.
        let rowStack = UIStackView(arrangedSubviews: [iconView, textStack, rightStack])
        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.spacing = 12
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rowStack)

        // Bottom constraint at priority 999 avoids conflicts while the cell is sizing itself.
        let bottom = rowStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        bottom.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            bottom,
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            rowStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rowStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
