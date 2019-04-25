//
//  MainViewController.swift
//  trello
//
//  Created by e.vanags on 13/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = TableHeaderView()
            tableView.tableFooterView = TableFooterView()
        }
    }

    private weak var safariController: SFSafariViewController?

    private var shouldAuthorize = true

    private var boards = Boards() {
        didSet {
            tableView.reloadData()
        }
    }

    private var noContent: Bool {
        return boards.isEmpty
    }

    private var hasContent: Bool {
        return !boards.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Boards"

        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard shouldAuthorize else {
            APIService.shared.fetchBoards { [weak self] result in
                switch result {
                case .success(let boards):
                    DispatchQueue.main.async {
                        self?.boards = boards
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

            return
        }

        APIService.shared.authorize { [weak self] (url) in
            guard let url = url else { return }

            DispatchQueue.main.async {
                let controller = SFSafariViewController(url: url)
                controller.modalPresentationStyle = .currentContext
                self?.safariController = controller

                self?.present(controller, animated: true)
            }
        }
    }

    private func bind() {
        APIService.shared.didAuthorize = { [weak self] in
            self?.shouldAuthorize = false

            DispatchQueue.main.async {
                self?.safariController?.dismiss(animated: true, completion: {
                    self?.safariController = nil
                })
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noContent {
            if let tableHeaderView = tableView.tableHeaderView as? TableHeaderView {
                tableHeaderView.separator.backgroundColor = .clear
            }

            if let tableFooterView = tableView.tableFooterView as? TableFooterView {
                tableFooterView.separator.backgroundColor = .clear
            }

            return 1
        } else {
            if let tableHeaderView = tableView.tableHeaderView as? TableHeaderView {
                tableHeaderView.separator.backgroundColor = .lightGray
            }

            if let tableFooterView = tableView.tableFooterView as? TableFooterView {
                tableFooterView.separator.backgroundColor = .lightGray
            }

            return boards.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noContent {
            return tableView.dequeueReusableCell(withType: NoContentTableViewCell.self, for: indexPath)!
        } else {
            let cell = tableView.dequeueReusableCell(withType: BoardTableViewCell.self, for: indexPath)!
            cell.configure(with: boards[indexPath.row].name)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tableHeaderHeight = tableView.tableHeaderView?.frame.height ?? 0
        let tableFooterHeight = tableView.tableFooterView?.frame.height ?? 0
        let bottomInsetHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let newHeight = tableView.frame.height - statusBarHeight - navigationBarHeight - tableHeaderHeight - tableFooterHeight - bottomInsetHeight

        return noContent ? newHeight : tableView.estimatedRowHeight
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard hasContent else { return }

        if let controller = storyboard?.instantiate(viewController: BoardViewController.self) {
            controller.title = boards[indexPath.row].name
            controller.identifier = boards[indexPath.row].id

            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
