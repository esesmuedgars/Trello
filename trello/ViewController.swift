//
//  ViewController.swift
//  trello
//
//  Created by e.vanags on 13/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    /// Defines how the token is returned to client.
    /// Should not be edited.
    let callbackMethod = "fragment"

    /// Redirect URL where the user will be redirected after authorization.
    /// Should not be edited.
    let returnUrl = "mytrelloapp:"

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
    let scope = "<#String#>"

    /// Indicator of when the token should expire.
    let expiration = "<#String#>"

    /// Name of the application.
    /// Displayed during the authorization process.
    let name = "<#String#>"

    /// API key.
    /// Used to generate the user's token.
    let key = "<#String#>"

    /// Response type of token.
    /// Should not be edited.
    let responseType = "token"

}

