//
//  DetailRowView.swift
//  TravelReimbursement
//
//  One "Title ........ Value" row used on the Trip Detail screen.
//

import UIKit

final class DetailRowView: UIStackView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String, value: String = "") {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        setUpViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(_ text: String, color: UIColor = Theme.Colors.primaryText) {
        valueLabel.text = text
        valueLabel.textColor = color
    }

    private func setUpViews() {
        axis = .horizontal
        alignment = .firstBaseline
        spacing = Theme.Spacing.small

        titleLabel.font = Theme.Fonts.body
        titleLabel.textColor = Theme.Colors.secondaryText
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        valueLabel.font = Theme.Fonts.body
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0

        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }
}
