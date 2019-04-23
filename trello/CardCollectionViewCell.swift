//
//  CardCollectionViewCell.swift
//  trello
//
//  Created by e.vanags on 24/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

public class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    public func configure(with title: String) {
        titleLabel.text = title
    }
}
