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
    @IBOutlet private var iconView: UIImageView!

    public func configure(with title: String) {
        titleLabel.text = title
        iconView.image = UIImage(named: "right-chevron")?.withRenderingMode(.alwaysTemplate)
    }
}
