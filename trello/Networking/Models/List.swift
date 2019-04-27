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

    /// The ID of the list.
    var id: String

    /// The name of the list.
    var name: String

    /// Array of card objects in this list.
    var cards: Cards
}
