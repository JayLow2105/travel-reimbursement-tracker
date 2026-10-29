//
//  TripListViewController.swift
//  TravelReimbursement
//
//  Screen 2: list of trips in a UITableView, with a status filter on top.
//

import UIKit

final class TripListViewController: UIViewController {

    // MARK: - Properties

    /// Index 0 = All, then one segment for each TripStatus.
    private static let filterTitles: [String] = ["All"] + TripStatus.allCases.map { $0.rawValue }
    private let filterControl = UISegmentedControl(items: TripListViewController.filterTitles)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyLabel = UILabel()

    /// Trips currently shown in the table (after filtering).
    private var visibleTrips: [Trip] = []

    private var selectedStatus: TripStatus? {
        let index = filterControl.selectedSegmentIndex
        return index == 0 ? nil : TripStatus.allCases[index - 1]
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Trips"
        view.backgroundColor = Theme.Colors.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped))
        setUpFilter()
        setUpTableView()
        setUpLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload so new or edited trips show up when coming back to this screen.
        reloadTrips()
    }

    // MARK: - Setup

    private func setUpFilter() {
        filterControl.selectedSegmentIndex = 0
        filterControl.translatesAutoresizingMaskIntoConstraints = false
        filterControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }

    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88

        emptyLabel.text = "No trips here yet.\nTap + to add one."
        emptyLabel.font = Theme.Fonts.body
        emptyLabel.textColor = Theme.Colors.secondaryText
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
    }

    private func setUpLayout() {
        view.addSubview(filterControl)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            filterControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.small),
            filterControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.Spacing.medium),
            filterControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Theme.Spacing.medium),

            tableView.topAnchor.constraint(equalTo: filterControl.bottomAnchor, constant: Theme.Spacing.small),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Data

    private func reloadTrips() {
        visibleTrips = TripStore.shared.trips(with: selectedStatus)
        tableView.backgroundView = visibleTrips.isEmpty ? emptyLabel : nil
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func filterChanged() {
        reloadTrips()
    }

    @objc private func addTapped() {
        navigationController?.pushViewController(AddEditTripViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TripListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleTrips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: visibleTrips[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        visibleTrips.isEmpty ? nil : "\(visibleTrips.count) trip(s)"
    }
}

// MARK: - UITableViewDelegate

extension TripListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trip = visibleTrips[indexPath.row]
        navigationController?.pushViewController(TripDetailViewController(tripID: trip.id), animated: true)
    }
}
