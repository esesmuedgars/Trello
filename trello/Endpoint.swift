//
//  Endpoint.swift
//  trello
//
//  Created by e.vanags on 14/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public enum Endpoint: String {
    case authorize = "authorize"

    private static var base = "https://trello.com/1"

    public func url(with queryItems: [URLQueryItem]? = nil) -> URL? {
        var url = URL(string: Endpoint.base)!
        url.appendPathComponent(rawValue)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        return components?.url
    }

    public func request(with queryItems: [URLQueryItem]? = nil) -> URLRequest {
        return URLRequest(url: url(with: queryItems)!)
    }
}
