//
//  TableFooterView.swift
//  trello
//
//  Created by e.vanags on 25/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

public class TableFooterView: UIView {

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
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
