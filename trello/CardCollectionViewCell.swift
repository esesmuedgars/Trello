//
//  CardCollectionViewCell.swift
//  trello
//
//  Created by e.vanags on 24/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

@IBDesignable
final public class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var labelStackView: UIStackView!

    @IBInspectable
    private var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public func configure(with card: Card) {
        titleLabel.text = card.name

        removeArrangedSubviews()

        card.labels.forEach { [weak self] label in
            let view = LabelView()
            view.backgroundColor = .color(label.colorName)

            self?.labelStackView.addArrangedSubview(view)
        }
    }

    private func removeArrangedSubviews() {
        labelStackView.arrangedSubviews.forEach { subview in
            labelStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
