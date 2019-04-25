//
//  BoardTableViewCell.swift
//  trello
//
//  Created by e.vanags on 22/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

public class BoardTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView! {
        didSet {
            iconView.image = UIImage(named: "right-chevron")
        }
    }

    public func configure(with title: String) {
        titleLabel.text = title
    }
}
