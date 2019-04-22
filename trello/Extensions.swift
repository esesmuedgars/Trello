//
//  Extensions.swift
//  trello
//
//  Created by e.vanags on 22/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<Cell>(withType type: Cell.Type, for indexPath: IndexPath) -> Cell? {
        return self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? Cell
    }
}
