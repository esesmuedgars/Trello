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

extension UIColor {
    private enum Color: String {
        case yellow, purple, blue, red, green, orange, black, sky, pink, lime, none

    }

    static func color(_ rawValue: String) -> UIColor? {
        guard let color = Color(rawValue: rawValue) else { return nil }

        switch color {
        case .yellow:
            return #colorLiteral(red: 0.949000001, green: 0.8389999866, blue: 0, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.7649999857, green: 0.4670000076, blue: 0.878000021, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0, green: 0.474999994, blue: 0.7490000129, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9219999909, green: 0.3529999852, blue: 0.275000006, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.3799999952, green: 0.7409999967, blue: 0.3100000024, alpha: 1)
        case .orange:
            return #colorLiteral(red: 1, green: 0.6240000129, blue: 0.1019999981, alpha: 1)
        case .black:
            return #colorLiteral(red: 0.2080000043, green: 0.3219999969, blue: 0.3880000114, alpha: 1)
        case .sky:
            return #colorLiteral(red: 0, green: 0.7609999776, blue: 0.878000021, alpha: 1)
        case .pink:
            return #colorLiteral(red: 1, green: 0.4709999859, blue: 0.7960000038, alpha: 1)
        case .lime:
            return #colorLiteral(red: 0.3179999888, green: 0.9100000262, blue: 0.5960000157, alpha: 1)
        default:
            return #colorLiteral(red: 0.7020000219, green: 0.7450000048, blue: 0.7689999938, alpha: 1)
        }
    }
}

extension Optional where Wrapped == String {
    var isEmpryOrNil: Bool {
        get {
            guard let self = self else { return true }
            return self.isEmpty
        }
    }
}
