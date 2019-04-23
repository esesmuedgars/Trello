//
//  BoardViewController.swift
//  trello
//
//  Created by e.vanags on 23/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final class BoardViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    public var identifier: String!

    private var lists = Lists() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        APIService.shared.fetchLists(ofBoard: identifier) { [weak self] result in
            switch result {
            case .success(let lists):
                self?.lists = lists
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension BoardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lists.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists[section].cards.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withType: ListCollectionHeaderView.self, for: indexPath) {
            let title = lists[indexPath.section].name
            view.configure(with: title)

            return view
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withType: CardCollectionViewCell.self, for: indexPath) {
            let title = lists[indexPath.section].cards[indexPath.row].name
            cell.configure(with: title)

            return cell
        }

        return UICollectionViewCell()
    }
}

extension BoardViewController: UICollectionViewDelegate {

}
