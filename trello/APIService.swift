//
//  APIService.swift
//  trello
//
//  Created by e.vanags on 14/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public struct APIService {

    public static var shared = APIService()

    private init() {}

    /// Defines how the token is returned to client.
    /// Should not be edited.
    private let callbackMethod = "fragment"

    /// Redirect URL where the user will be redirected after authorization.
    /// Should not be edited.
    private let returnUrl = "trello:"

    /// Permission scope.
    ///
    /// - `read`
    /// reading of boards, organizations, etc. on behalf of the user.
    ///
    /// - `write`
    /// writing of boards, organizations, etc. on behalf of the user.
    ///
    /// - `account`
    /// writing of member info, and marking notifications read.
    private let scope = "read,write,account"

    /// Indicator of when the token should expire.
    private let expiration = "never"

    /// Name of the application.
    /// Displayed during the authorization process.
    private let name = "Trello"

    /// API key.
    /// Used to generate the user's token.
    private let key = "ec7f9116940939593356a6591e35029c"

    /// Response type of token.
    /// Should not be edited.
    private let responseType = "token"

    public var didAuthorize: (() -> Void)?

    var token: String? {
        didSet {
            didAuthorize?()
        }
    }

    public func authorize(completionHandler completion: @escaping (URL?) -> Void) {
        let queryItems = [
            URLQueryItem(name: "callback_method", value: callbackMethod),
            URLQueryItem(name: "return_url", value: returnUrl),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "expiration", value: expiration),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "response_type", value: responseType)
        ]

        let url = Endpoint.authorize.url(with: queryItems)

        completion(url)
    }
}
