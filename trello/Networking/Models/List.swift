//
//  List.swift
//  trello
//
//  Created by e.vanags on 23/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public typealias Lists = [List]

public struct List: Codable {

    var id: String

    var name: String

    var cards: Cards

}
