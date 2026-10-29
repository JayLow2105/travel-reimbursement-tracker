//
//  FormFieldView.swift
//  TravelReimbursement
//
//  A caption above a text field, used on the Add/Edit Trip form.
//

import UIKit

final class FormFieldView: UIStackView {

    let textField = UITextField()
    private let captionLabel = UILabel()

    init(caption: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        captionLabel.text = caption
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        setUpViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    private func setUpViews() {
        axis = .vertical
        spacing = 4

        captionLabel.font = Theme.Fonts.caption
        captionLabel.textColor = Theme.Colors.secondaryText

        textField.borderStyle = .roundedRect
        textField.font = Theme.Fonts.body
        textField.clearButtonMode = .whileEditing
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        addArrangedSubview(captionLabel)
        addArrangedSubview(textField)
    }
}
