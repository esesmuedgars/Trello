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

    public static var `default` = Card()

    /// The ID of the card.
    var id: String

    /// Name of the card.
    var name: String

    /// The description for the card. Up to 16384 chars.
    var desc: String?

    /// Array of label objects on this card.
    var labels: Labels

    private init() {
        self.id = ""
        self.name = ""
        self.desc = nil
        self.labels = []
    }
}
