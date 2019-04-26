//
//  BoardViewController.swift
//  trello
//
//  Created by e.vanags on 23/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class BoardViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var noContentView: UIView!
    @IBOutlet private var noContentImageView: UIImageView! {
        didSet {
            noContentImageView.image = UIImage(named: "no-content")
        }
    }

    public var identifier: String!

    private var lists = Lists() {
        didSet {
            noContentView.isHidden = !lists.isEmpty
            collectionView.reloadData()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        APIService.shared.fetchLists(ofBoard: identifier) { [weak self] result in
            switch result {
            case .success(let lists):
                DispatchQueue.main.async {
                    self?.lists = lists
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension BoardViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lists.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists[section].cards.count
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withType: ListCollectionHeaderView.self, for: indexPath) {
            view.configure(with: lists[indexPath.section])

            return view
        }

        return UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withType: CardCollectionViewCell.self, for: indexPath) {
            cell.configure(with: lists[indexPath.section].cards[indexPath.row])

            return cell
        }

        return UICollectionViewCell()
    }
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 65)
    }
}

extension BoardViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiate(viewController: CardViewController.self) {
            let card = lists[indexPath.section].cards[indexPath.row]

            controller.title = card.name
            controller.identifier = card.id

            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
