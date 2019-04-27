//
//  LabelCollectionViewCell.swift
//  trello
//
//  Created by e.vanags on 27/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

@IBDesignable
final public class LabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    @IBInspectable
    private var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public func configure(with label: Label) {
        titleLabel.text = label.name
        backgroundColor = .color(label.colorName)
    }
}
