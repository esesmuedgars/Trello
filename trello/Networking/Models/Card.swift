//
//  Card.swift
//  trello
//
//  Created by e.vanags on 23/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public typealias Cards = [Card]

public struct Card: Codable {

    /// The ID of the card
    var id: String

    /// Name of the card
    var name: String

    /// Array of label objects on this card
    var labels: Labels
}
