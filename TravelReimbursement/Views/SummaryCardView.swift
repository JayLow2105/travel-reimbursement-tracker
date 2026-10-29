//
//  SummaryCardView.swift
//  TravelReimbursement
//
//  Small card on the Home screen: an icon, a big value, and a caption.
//

import UIKit

final class SummaryCardView: UIView {

    private let iconView = UIImageView()
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init(title: String, systemImage: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        iconView.image = UIImage(systemName: systemImage)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(_ text: String, color: UIColor = Theme.Colors.primaryText) {
        valueLabel.text = text
        valueLabel.textColor = color
    }

    private func setUpViews() {
        backgroundColor = Theme.Colors.card
        layer.cornerRadius = Theme.cornerRadius

        iconView.tintColor = Theme.Colors.primary
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = Theme.Fonts.largeValue
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.6

        titleLabel.font = Theme.Fonts.caption
        titleLabel.textColor = Theme.Colors.secondaryText

        // Icon on top, then the value, then the caption.
        let stack = UIStackView(arrangedSubviews: [iconView, valueLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: Theme.Spacing.medium),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.Spacing.medium),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Theme.Spacing.medium),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Theme.Spacing.medium)
        ])
    }
}
