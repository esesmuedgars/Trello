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
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? Cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<Cell>(withType type: Cell.Type, for indexPath: IndexPath) -> Cell? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? Cell
    }

    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(ofKind kind: String, withType type: View.Type, for indexPath: IndexPath) -> View? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: type), for: indexPath) as? View
    }
}

extension UIStoryboard {
    func instantiate<Controller>(viewController type: Controller.Type) -> Controller? {
        return instantiateViewController(withIdentifier: String(describing: type)) as? Controller
    }
}
