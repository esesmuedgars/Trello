//
//  ListCollectionHeaderView.swift
//  trello
//
//  Created by e.vanags on 24/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class ListCollectionHeaderView: UICollectionReusableView {

    @IBOutlet private var titleLabel: UILabel!

    public func configure(with list: List) {
        titleLabel.text = list.name
    }
}
