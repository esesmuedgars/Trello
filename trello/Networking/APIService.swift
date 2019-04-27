//
//  APIService.swift
//  trello
//
//  Created by e.vanags on 14/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case invalidURL
    case responseNoData
    case unableToParseResponse
    case unexpectedStatusCode
}

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

    /// Trello interprets `me` in the place of a `memberID` as a reference to the user who is making the request based on the API token.
    private let memberId = "me"

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

        let url = Endpoint.authorize.url(queryItems: queryItems)

        completion(url)
    }

    public func fetchBoards(completionHandler completion: @escaping (Result<Boards, NetworkingError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "token", value: token)
        ]

        guard let url = Endpoint.boards(ofMember: memberId).url(queryItems: queryItems) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.responseNoData))
                return
            }

            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }

            do {
                completion(.success(try JSONDecoder().decode(Boards.self, from: data)))
            } catch {
                completion(.failure(.unableToParseResponse))
            }
        }.resume()
    }

    /// One of: `all`, `closed`, `none`, `open`.
    private let cards = "open"

    /// `all` or a comma-separated list of card [fields](https://developers.trello.com/reference#card-object).
    private let cardFields = "id,name,desc,labels"

    /// One of `all`, `closed`, `none`, `open`.
    private let filter = "open"

    /// `all` or a comma-separated list of list [fields](https://developers.trello.com/reference#list-object).
    private var fields = "id,name"

    public func fetchLists(ofBoard boardId: String, completionHandler completion: @escaping (Result<Lists, NetworkingError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "cards", value: cards),
            URLQueryItem(name: "card_fields", value: cardFields),
            URLQueryItem(name: "filter", value: filter),
            URLQueryItem(name: "fields", value: fields)
        ]

        guard let url = Endpoint.lists(ofBoard: boardId).url(queryItems: queryItems) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.responseNoData))
                return
            }

            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }

            do {
                completion(.success(try JSONDecoder().decode(Lists.self, from: data)))
            } catch {
                completion(.failure(.unableToParseResponse))
            }
        }.resume()
    }

    /// `true`, `false`, or `cover`
    private let attachments = "false"

    /// Whether to return the checklists on the card. `all` or `none`
    private let checklists = "none"

    public func fetchCard(withId cardId: String, completionHandler completion: @escaping (Result<Card, NetworkingError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "id", value: cardId),
            URLQueryItem(name: "fields", value: cardFields),
        ]

        guard let url = Endpoint.card(withId: cardId).url(queryItems: queryItems) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.responseNoData))
                return
            }

            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }

            do {
                completion(.success(try JSONDecoder().decode(Card.self, from: data)))
            } catch {
                completion(.failure(.unableToParseResponse))
            }
        }.resume()
    }

    public func updateCard(withId cardId: String, description: String?, completionHandler completion: @escaping (Result<Void, NetworkingError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "id", value: cardId),
            URLQueryItem(name: "value", value: description)
        ]

        var request = Endpoint.card(withId: cardId).request(with: ["desc"], queryItems: queryItems)
        request.httpMethod = "PUT"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else {
                completion(.failure(.responseNoData))
                return
            }

            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }

            completion(.success(()))
            }.resume()
    }


    public func deleteCard(withId cardId: String, completionHandler completion: @escaping (Result<Void, NetworkingError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "id", value: cardId)
        ]

        var request = Endpoint.card(withId: cardId).request(queryItems: queryItems)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else {
                completion(.failure(.responseNoData))
                return
            }

            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }

            completion(.success(()))
        }.resume()
    }
}
