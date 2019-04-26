//
//  NoContentTableViewCell.swift
//  trello
//
//  Created by e.vanags on 24/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class NoContentTableViewCell: UITableViewCell {

    @IBOutlet private var iconView: UIImageView! {
        didSet {
            iconView.image = UIImage(named: "no-content")
        }
    }
}
