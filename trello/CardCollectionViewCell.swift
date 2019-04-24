//
//  CardCollectionViewCell.swift
//  trello
//
//  Created by e.vanags on 24/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

@IBDesignable
public class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    @IBInspectable
    private var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public func configure(with title: String) {
        titleLabel.text = title
    }
}
