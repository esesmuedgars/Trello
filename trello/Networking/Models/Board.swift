//
//  Board.swift
//  trello
//
//  Created by e.vanags on 22/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public typealias Boards = [Board]

public struct Board: Codable {

    /// The ID of the board.
    var id: String

    /// The name of the board.
    var name: String
}
