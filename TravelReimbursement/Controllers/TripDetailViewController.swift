//
//  TripDetailViewController.swift
//  TravelReimbursement
//
//  Screen 3: everything about one trip, plus how the reimbursement was calculated.
//

import UIKit

final class TripDetailViewController: UIViewController {

    // MARK: - Properties

    private let tripID: UUID
    private var trip: Trip? { TripStore.shared.trip(withID: tripID) }

    // MARK: - Views

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    // Header
    private let amountLabel = UILabel()
    private let purposeLabel = UILabel()
    private let statusBadge = StatusBadgeLabel()

    // Route map placeholder
    private let mapImageView = UIImageView(image: UIImage(systemName: "map.fill"))

    // Rows
    private let fromRow = DetailRowView(title: "From")
    private let toRow = DetailRowView(title: "To")
    private let dateRow = DetailRowView(title: "Date")
    private let distanceRow = DetailRowView(title: "Distance")
    private let mpgRow = DetailRowView(title: "Vehicle MPG")
    private let gallonsRow = DetailRowView(title: "Gas used")
    private let gasPriceRow = DetailRowView(title: "Gas price")
    private let totalRow = DetailRowView(title: "Reimbursement")
    private let notesLabel = UILabel()

    private let submitButton = Theme.makePrimaryButton(title: "Submit for Reimbursement", systemImage: "paperplane.fill")

    // MARK: - Init

    init(tripID: UUID) {
        self.tripID = tripID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trip Details"
        view.backgroundColor = Theme.Colors.background
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editTapped))
        setUpLayout()
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh in case the trip was changed on the Edit screen.
        updateValues()
    }

    // MARK: - Layout

    private func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = Theme.Spacing.medium
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Theme.Spacing.medium),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Theme.Spacing.medium),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Theme.Spacing.medium),
            // Content is as wide as the screen, so the page only scrolls vertically.
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Theme.Spacing.medium)
        ])

        contentStack.addArrangedSubview(makeHeaderCard())
        contentStack.addArrangedSubview(makeMapPlaceholder())
        contentStack.addArrangedSubview(makeCard(title: "Route", rows: [fromRow, toRow, dateRow]))
        contentStack.addArrangedSubview(makeCard(title: "Calculation",
                                                 rows: [distanceRow, mpgRow, gallonsRow, gasPriceRow, makeDivider(), totalRow]))

        notesLabel.font = Theme.Fonts.body
        notesLabel.numberOfLines = 0
        contentStack.addArrangedSubview(makeCard(title: "Notes", rows: [notesLabel]))
        contentStack.addArrangedSubview(submitButton)
    }

    /// Big amount, trip purpose and status at the top of the screen.
    private func makeHeaderCard() -> UIView {
        amountLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        amountLabel.textColor = Theme.Colors.money
        amountLabel.textAlignment = .center

        purposeLabel.font = Theme.Fonts.title
        purposeLabel.textAlignment = .center
        purposeLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [amountLabel, purposeLabel, statusBadge])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Theme.Spacing.small
        return wrapInCard(stack)
    }

    /// Placeholder for the GPS route map that will be added in Milestone 3.
    private func makeMapPlaceholder() -> UIView {
        mapImageView.tintColor = Theme.Colors.primary.withAlphaComponent(0.6)
        mapImageView.contentMode = .scaleAspectFit

        let caption = UILabel()
        caption.text = "Route map (GPS) coming soon"
        caption.font = Theme.Fonts.caption
        caption.textColor = Theme.Colors.secondaryText
        caption.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [mapImageView, caption])
        stack.axis = .vertical
        stack.spacing = Theme.Spacing.small
        mapImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return wrapInCard(stack)
    }

    private func makeCard(title: String, rows: [UIView]) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.Fonts.title

        let stack = UIStackView(arrangedSubviews: [titleLabel] + rows)
        stack.axis = .vertical
        stack.spacing = 10
        return wrapInCard(stack)
    }

    private func makeDivider() -> UIView {
        let line = UIView()
        line.backgroundColor = .separator
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
    }

    /// Puts content inside a rounded card with padding on every side.
    private func wrapInCard(_ content: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.card
        card.layer.cornerRadius = Theme.cornerRadius
        content.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: card.topAnchor, constant: Theme.Spacing.medium),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Theme.Spacing.medium),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Theme.Spacing.medium),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Theme.Spacing.medium)
        ])
        return card
    }

    // MARK: - Data

    private func updateValues() {
        guard let trip = trip else { return }

        amountLabel.text = Formatters.currency(trip.reimbursementAmount)
        purposeLabel.text = trip.purpose
        statusBadge.configure(with: trip.status)

        fromRow.setValue(trip.startLocation)
        toRow.setValue(trip.endLocation)
        dateRow.setValue(Formatters.date(trip.date))
        distanceRow.setValue(Formatters.miles(trip.distanceMiles))
        mpgRow.setValue("\(Int(trip.vehicleMPG)) MPG")
        gallonsRow.setValue(String(format: "%.2f gal", trip.gallonsUsed))
        gasPriceRow.setValue("\(Formatters.currency(trip.gasPricePerGallon)) / gal")
        totalRow.setValue(Formatters.currency(trip.reimbursementAmount), color: Theme.Colors.money)
        notesLabel.text = trip.notes.isEmpty ? "No notes" : trip.notes
        notesLabel.textColor = trip.notes.isEmpty ? Theme.Colors.secondaryText : Theme.Colors.primaryText

        // Only pending trips can be submitted.
        submitButton.isHidden = trip.status != .pending
    }

    // MARK: - Actions

    @objc private func editTapped() {
        guard let trip = trip else { return }
        navigationController?.pushViewController(AddEditTripViewController(trip: trip), animated: true)
    }

    @objc private func submitTapped() {
        guard var trip = trip else { return }
        trip.status = .submitted
        TripStore.shared.save(trip)
        updateValues()

        let alert = UIAlertController(title: "Submitted",
                                      message: "Your reimbursement request of \(Formatters.currency(trip.reimbursementAmount)) was submitted.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
