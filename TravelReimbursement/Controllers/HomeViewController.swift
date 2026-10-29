//
//  HomeViewController.swift
//  TravelReimbursement
//
//  Screen 1: entry point. Shows a summary of the employee's trips and
//  buttons to start a new trip or see all trips.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Views

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let owedCard = SummaryCardView(title: "Waiting to be paid", systemImage: "clock.fill")
    private let tripsCard = SummaryCardView(title: "Trips", systemImage: "car.fill")
    private let milesCard = SummaryCardView(title: "Miles driven", systemImage: "road.lanes")
    private let totalCard = SummaryCardView(title: "Total reimbursement", systemImage: "dollarsign.circle.fill")

    private let settingsLabel = UILabel()

    private let newTripButton = Theme.makePrimaryButton(title: "Start New Trip", systemImage: "plus.circle.fill")
    private let viewTripsButton = Theme.makeSecondaryButton(title: "View All Trips", systemImage: "list.bullet")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mileage Pay"
        view.backgroundColor = Theme.Colors.background
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonDisplayMode = .minimal

        setUpLayout()
        newTripButton.addTarget(self, action: #selector(newTripTapped), for: .touchUpInside)
        viewTripsButton.addTarget(self, action: #selector(viewTripsTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Totals change after a trip is added or edited.
        updateSummary()
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

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Theme.Spacing.small),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Theme.Spacing.medium),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Theme.Spacing.medium),
            // Content is as wide as the screen, so the page only scrolls vertically.
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Theme.Spacing.medium)
        ])

        // Welcome text
        welcomeLabel.text = "Welcome back!"
        welcomeLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitleLabel.text = "Track the miles you drive for work and get paid back for gas."
        subtitleLabel.font = Theme.Fonts.body
        subtitleLabel.textColor = Theme.Colors.secondaryText
        subtitleLabel.numberOfLines = 0

        let headerStack = UIStackView(arrangedSubviews: [welcomeLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 4
        contentStack.addArrangedSubview(headerStack)

        // Summary cards: one wide card, then two small cards side by side, then one wide card.
        contentStack.addArrangedSubview(owedCard)

        let smallCardsRow = UIStackView(arrangedSubviews: [tripsCard, milesCard])
        smallCardsRow.axis = .horizontal
        smallCardsRow.distribution = .fillEqually
        smallCardsRow.spacing = Theme.Spacing.medium
        contentStack.addArrangedSubview(smallCardsRow)

        contentStack.addArrangedSubview(totalCard)

        // Current default gas price and MPG used for new trips.
        settingsLabel.font = Theme.Fonts.caption
        settingsLabel.textColor = Theme.Colors.secondaryText
        settingsLabel.textAlignment = .center
        settingsLabel.numberOfLines = 0
        contentStack.addArrangedSubview(settingsLabel)

        // Main actions
        contentStack.setCustomSpacing(Theme.Spacing.large, after: settingsLabel)
        let buttonStack = UIStackView(arrangedSubviews: [newTripButton, viewTripsButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        contentStack.addArrangedSubview(buttonStack)
    }

    // MARK: - Data

    private func updateSummary() {
        let store = TripStore.shared
        owedCard.setValue(Formatters.currency(store.amountOwed), color: .systemOrange)
        tripsCard.setValue("\(store.trips.count)")
        milesCard.setValue(Formatters.miles(store.totalMiles))
        totalCard.setValue(Formatters.currency(store.totalReimbursement), color: Theme.Colors.money)
        settingsLabel.text = "Default gas price \(Formatters.currency(store.defaultGasPrice))/gal • Vehicle \(Int(store.defaultVehicleMPG)) MPG"
    }

    // MARK: - Navigation

    @objc private func newTripTapped() {
        navigationController?.pushViewController(AddEditTripViewController(), animated: true)
    }

    @objc private func viewTripsTapped() {
        navigationController?.pushViewController(TripListViewController(), animated: true)
    }
}
