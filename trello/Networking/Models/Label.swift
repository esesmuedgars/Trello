//
//  Label.swift
//  trello
//
//  Created by e.vanags on 23/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public typealias Labels = [Label]

public struct Label: Codable {

    /// The ID of the label
    var id: String

    /// The optional name of the label (0 - 16384 chars)
    var name: String

    /// The color of the label. One of:
    /// yellow, purple, blue, red, green, orange, black, sky, pink, lime, null
    /// (null means no color, and the label will not show on the front of cards)
    private var color: String?

    var colorName: String {
        return color ?? "none"
    }
}
