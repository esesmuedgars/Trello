//
//  TableHeaderView.swift
//  trello
//
//  Created by e.vanags on 25/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class TableHeaderView: UIView {

    public lazy var separator = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        frame.size.height = 20

        addSubview(separator)

        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
