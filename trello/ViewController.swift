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

    private weak var safariController: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        APIService.shared.didAuthorize = { [weak self] in
            self?.shouldAuthorize = false

            self?.safariController?.dismiss(animated: true, completion: {
                self?.safariController = nil
            })
        }
    }

    private var shouldAuthorize = true

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard shouldAuthorize else { return }

        APIService.shared.authorize { [weak self] (url) in
            guard let url = url else { return }

            DispatchQueue.main.async {
                let controller = SFSafariViewController(url: url)
                self?.safariController = controller

                self?.present(controller, animated: true)
            }
        }
    }
}

