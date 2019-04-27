//
//  MainViewController.swift
//  trello
//
//  Created by e.vanags on 13/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit
import SafariServices

final public class MainViewController: UIViewController {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = TableHeaderView()
            tableView.tableFooterView = TableFooterView()
        }
    }

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Boards"

        return controller
    }()

    private weak var safariController: SFSafariViewController?

    private var shouldAuthorize = true

    private var filteredBoards = Boards() {
        didSet {
            tableView.reloadData()
        }
    }

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

    private var isFiltering: Bool {
        let noSearchInput = searchController.searchBar.text?.isEmpty ?? true
        return searchController.isActive && !noSearchInput
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "Boards"

        navigationItem.searchController = searchController
        definesPresentationContext = true

        bind()
    }

    override public func viewDidAppear(_ animated: Bool) {
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
                // TODO: Fix modal transition not recalling authorize if SF was dismissed
                controller.modalPresentationStyle = .fullScreen
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

    private func setSeparator(color: UIColor) {
        if let tableHeaderView = tableView.tableHeaderView as? TableHeaderView {
            tableHeaderView.separator.backgroundColor = color
        }

        if let tableFooterView = tableView.tableFooterView as? TableFooterView {
            tableFooterView.separator.backgroundColor = color
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let input = searchController.searchBar.text {
            filteredBoards = boards.filter { board in
                board.name.lowercased().contains(input.lowercased())
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noContent {
            setSeparator(color: .clear)

            return 1
        } else {
            if isFiltering {
                setSeparator(color: filteredBoards.isEmpty ? .clear : .lightGray)

                return filteredBoards.count
            } else {
                setSeparator(color: .lightGray)

                return boards.count
            }
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noContent {
            return tableView.dequeueReusableCell(withType: NoContentTableViewCell.self, for: indexPath)!
        } else {
            let cell = tableView.dequeueReusableCell(withType: BoardTableViewCell.self, for: indexPath)!
            cell.configure(with: isFiltering ? filteredBoards[indexPath.row] : boards[indexPath.row])

            return cell
        }
    }
}

extension MainViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tableHeaderHeight = tableView.tableHeaderView?.frame.height ?? 0
        let tableFooterHeight = tableView.tableFooterView?.frame.height ?? 0
        let bottomInsetHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let newHeight = tableView.frame.height - statusBarHeight - navigationBarHeight - tableHeaderHeight - tableFooterHeight - bottomInsetHeight

        return noContent ? newHeight : tableView.estimatedRowHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard hasContent else { return }

        if let controller = storyboard?.instantiate(viewController: BoardViewController.self) {
            let board = isFiltering ? filteredBoards[indexPath.row] : boards[indexPath.row]

            controller.title = board.name
            controller.identifier = board.id

            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
