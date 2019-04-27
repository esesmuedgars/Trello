//
//  Endpoint.swift
//  trello
//
//  Created by e.vanags on 14/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public enum Endpoint {
    case authorize
    case boards(ofMember: String)
    case lists(ofBoard: String)
    case card(withId: String)

    private var rawValue: String {
        get {
            switch self {
            case .authorize:
                return "authorize"
            case .boards(let memberId):
                return "members/\(memberId)/boards"
            case .lists(let boardId):
                return "boards/\(boardId)/lists"
            case .card(let cardId):
                return "cards/\(cardId)"
            }
        }
    }

    private static var base = "https://trello.com/1"

    public func url(with pathComponents: [String] = [], queryItems: [URLQueryItem]? = nil) -> URL? {
        var url = URL(string: Endpoint.base)!
        url.appendPathComponent(rawValue)

        for component in pathComponents {
            url.appendPathComponent(component)
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        return components?.url
    }

    public func request(with pathComponents: [String] = [], queryItems: [URLQueryItem]? = nil) -> URLRequest {
        return URLRequest(url: url(with: pathComponents, queryItems: queryItems)!)
    }
}
