//
//  AddEditTripViewController.swift
//  TravelReimbursement
//
//  Screen 4: form for adding a new trip or editing an existing one.
//
//  The form is a vertical UIStackView inside a UIScrollView so it still works
//  on small screens and when the keyboard is showing.
//

import UIKit

final class AddEditTripViewController: UIViewController {

    // MARK: - Properties

    /// nil when adding a new trip; set when editing.
    private let existingTrip: Trip?

    private var isEditingTrip: Bool { existingTrip != nil }

    // MARK: - Views

    private let scrollView = UIScrollView()
    private let formStack = UIStackView()

    private let purposeField = FormFieldView(caption: "Trip purpose", placeholder: "e.g. Client meeting")
    private let startField = FormFieldView(caption: "From", placeholder: "Starting location")
    private let endField = FormFieldView(caption: "To", placeholder: "Destination")
    private let datePicker = UIDatePicker()

    private let gpsSwitch = UISwitch()
    private let gpsHintLabel = UILabel()
    private let distanceField = FormFieldView(caption: "Distance (miles)", placeholder: "0.0", keyboardType: .decimalPad)
    private let gasPriceField = FormFieldView(caption: "Gas price ($ per gallon)", placeholder: "4.89", keyboardType: .decimalPad)

    private let mpgSlider = UISlider()
    private let mpgValueLabel = UILabel()

    private let statusControl = UISegmentedControl(items: TripStatus.allCases.map { $0.rawValue })
    private let notesTextView = UITextView()

    private let estimateLabel = UILabel()
    private let saveButton = Theme.makePrimaryButton(title: "Save Trip", systemImage: "checkmark.circle.fill")

    // MARK: - Init

    init(trip: Trip? = nil) {
        self.existingTrip = trip
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = isEditingTrip ? "Edit Trip" : "New Trip"
        view.backgroundColor = Theme.Colors.background
        navigationItem.largeTitleDisplayMode = .never

        setUpScrollView()
        setUpForm()
        setUpActions()
        fillInValues()
        updateEstimate()
    }

    // MARK: - Layout

    private func setUpScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        formStack.axis = .vertical
        formStack.spacing = Theme.Spacing.medium
        formStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(formStack)

        NSLayoutConstraint.activate([
            // Scroll view fills the safe area and stops above the keyboard.
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            // Form stack is pinned to the scroll view's content.
            formStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Theme.Spacing.medium),
            formStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            formStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Theme.Spacing.medium),
            formStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Theme.Spacing.medium),
            // Content is as wide as the screen, so the page only scrolls vertically.
            formStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Theme.Spacing.medium)
        ])
    }

    private func setUpForm() {
        // Section: where and when
        formStack.addArrangedSubview(makeSectionHeader("Trip Info"))
        formStack.addArrangedSubview(purposeField)
        formStack.addArrangedSubview(startField)
        formStack.addArrangedSubview(endField)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        formStack.addArrangedSubview(makeRow(title: "Date", control: datePicker))

        // Section: distance and cost
        formStack.setCustomSpacing(Theme.Spacing.large, after: formStack.arrangedSubviews.last!)
        formStack.addArrangedSubview(makeSectionHeader("Distance & Gas"))

        gpsSwitch.onTintColor = Theme.Colors.primary
        formStack.addArrangedSubview(makeRow(title: "Track distance with GPS", control: gpsSwitch))

        gpsHintLabel.text = "GPS tracking will be added in a later milestone. Enter the distance manually for now."
        gpsHintLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        gpsHintLabel.textColor = Theme.Colors.secondaryText
        gpsHintLabel.numberOfLines = 0
        gpsHintLabel.isHidden = true
        formStack.addArrangedSubview(gpsHintLabel)

        // Distance and gas price side by side.
        let numbersRow = UIStackView(arrangedSubviews: [distanceField, gasPriceField])
        numbersRow.axis = .horizontal
        numbersRow.distribution = .fillEqually
        numbersRow.spacing = Theme.Spacing.medium
        formStack.addArrangedSubview(numbersRow)

        // Vehicle MPG slider with its current value on the right.
        let mpgTitle = UILabel()
        mpgTitle.text = "Vehicle fuel economy"
        mpgTitle.font = Theme.Fonts.caption
        mpgTitle.textColor = Theme.Colors.secondaryText
        mpgValueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        mpgValueLabel.textAlignment = .right
        let mpgHeader = UIStackView(arrangedSubviews: [mpgTitle, mpgValueLabel])
        mpgHeader.axis = .horizontal

        mpgSlider.minimumValue = 10
        mpgSlider.maximumValue = 60
        mpgSlider.minimumTrackTintColor = Theme.Colors.primary

        let mpgStack = UIStackView(arrangedSubviews: [mpgHeader, mpgSlider])
        mpgStack.axis = .vertical
        mpgStack.spacing = 4
        formStack.addArrangedSubview(mpgStack)

        // Section: status and notes
        formStack.setCustomSpacing(Theme.Spacing.large, after: mpgStack)
        formStack.addArrangedSubview(makeSectionHeader("Status & Notes"))
        formStack.addArrangedSubview(statusControl)

        notesTextView.font = Theme.Fonts.body
        notesTextView.backgroundColor = Theme.Colors.card
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.separator.cgColor
        notesTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        formStack.addArrangedSubview(notesTextView)

        // Live estimate + save button
        formStack.setCustomSpacing(Theme.Spacing.large, after: notesTextView)
        estimateLabel.font = Theme.Fonts.title
        estimateLabel.textColor = Theme.Colors.money
        estimateLabel.textAlignment = .center
        estimateLabel.numberOfLines = 0
        formStack.addArrangedSubview(estimateLabel)
        formStack.addArrangedSubview(saveButton)
    }

    private func makeSectionHeader(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = Theme.Colors.secondaryText
        return label
    }

    /// Horizontal row with a label on the left and a control on the right.
    private func makeRow(title: String, control: UIView) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = Theme.Fonts.body
        let row = UIStackView(arrangedSubviews: [label, control])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = Theme.Spacing.small
        control.setContentHuggingPriority(.required, for: .horizontal)
        return row
    }

    // MARK: - Actions

    private func setUpActions() {
        for field in [distanceField, gasPriceField] {
            field.textField.addTarget(self, action: #selector(valuesChanged), for: .editingChanged)
        }
        mpgSlider.addTarget(self, action: #selector(valuesChanged), for: .valueChanged)
        gpsSwitch.addTarget(self, action: #selector(gpsSwitchChanged), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveTapped))

        // Tapping outside a text field hides the keyboard.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func valuesChanged() {
        updateEstimate()
    }

    @objc private func gpsSwitchChanged() {
        UIView.animate(withDuration: 0.25) {
            self.gpsHintLabel.isHidden = !self.gpsSwitch.isOn
        }
    }

    @objc private func saveTapped() {
        let purpose = purposeField.text.trimmingCharacters(in: .whitespaces)
        guard !purpose.isEmpty else {
            showAlert(title: "Missing purpose", message: "Please enter what the trip was for.")
            return
        }
        guard let miles = Double(distanceField.text), miles > 0 else {
            showAlert(title: "Missing distance", message: "Please enter how many miles you drove.")
            return
        }

        let trip = Trip(id: existingTrip?.id ?? UUID(),
                        purpose: purpose,
                        startLocation: startField.text,
                        endLocation: endField.text,
                        date: datePicker.date,
                        distanceMiles: miles,
                        gasPricePerGallon: Double(gasPriceField.text) ?? TripStore.shared.defaultGasPrice,
                        vehicleMPG: Double(mpgSlider.value.rounded()),
                        notes: notesTextView.text,
                        status: TripStatus.allCases[statusControl.selectedSegmentIndex])

        // Milestone 1: trips are kept in memory only.
        TripStore.shared.save(trip)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helpers

    private func fillInValues() {
        let store = TripStore.shared
        if let trip = existingTrip {
            purposeField.text = trip.purpose
            startField.text = trip.startLocation
            endField.text = trip.endLocation
            datePicker.date = trip.date
            distanceField.text = String(trip.distanceMiles)
            gasPriceField.text = String(trip.gasPricePerGallon)
            mpgSlider.value = Float(trip.vehicleMPG)
            statusControl.selectedSegmentIndex = TripStatus.allCases.firstIndex(of: trip.status) ?? 0
            notesTextView.text = trip.notes
        } else {
            gasPriceField.text = String(store.defaultGasPrice)
            mpgSlider.value = Float(store.defaultVehicleMPG)
            statusControl.selectedSegmentIndex = 0
        }
    }

    private func updateEstimate() {
        let mpg = Double(mpgSlider.value.rounded())
        mpgValueLabel.text = "\(Int(mpg)) MPG"

        let miles = Double(distanceField.text) ?? 0
        let gasPrice = Double(gasPriceField.text) ?? 0
        let amount = Trip.reimbursement(miles: miles, mpg: mpg, gasPrice: gasPrice)
        estimateLabel.text = "Estimated reimbursement: \(Formatters.currency(amount))"
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
