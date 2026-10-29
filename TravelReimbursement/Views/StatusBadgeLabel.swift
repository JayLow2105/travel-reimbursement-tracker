//
//  StatusBadgeLabel.swift
//  TravelReimbursement
//
//  Rounded colored label that shows a trip's status (Pending / Submitted / Paid).
//

import UIKit

final class StatusBadgeLabel: UILabel {

    private let padding = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.preferredFont(forTextStyle: .caption1)
        textAlignment = .center
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with status: TripStatus) {
        text = status.rawValue
        let color: UIColor
        switch status {
        case .pending: color = .systemOrange
        case .submitted: color = .systemBlue
        case .paid: color = .systemGreen
        }
        textColor = color
        backgroundColor = color.withAlphaComponent(0.15)
    }

    // Add padding around the text so the badge looks like a pill.
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
