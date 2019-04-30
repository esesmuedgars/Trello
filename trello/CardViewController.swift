//
//  CardViewController.swift
//  trello
//
//  Created by e.vanags on 26/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class CardViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var labelContainerView: UIView! {
        didSet {
            labelContainerView.isHidden = true
        }
    }
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
    @IBOutlet private var collectionViewLayout: CardLabelCollectionViewLayout! {
        didSet {
            collectionViewLayout.delegate = self
        }
    }
    @IBOutlet private var toolbarView: UIView!
    @IBOutlet private var textViewContainer: UIView! {
        didSet {
            textViewContainer.layer.cornerRadius = 5
            textViewContainer.layer.borderWidth = 0.5
            textViewContainer.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var placeholderLabel: UILabel!
    @IBOutlet private var containerBottomConstraint: NSLayoutConstraint!

    private var tapGestureRecognizer: UITapGestureRecognizer!

    @IBAction func didTouchUpInsideSave() {
        APIService.shared.updateCard(withId: identifier, description: textView.text) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.textView.resignFirstResponder()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    public var identifier: String!
    private var card: Card = .default {
        didSet {
            titleLabel.text = card.name
            textView.text = card.desc

            placeholderLabel.isHidden = !card.desc.isEmpryOrNil
            labelContainerView.isHidden = card.labels.isEmpty

            collectionView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCard))

        textView.inputAccessoryView = toolbarView

        title = "Card"

        APIService.shared.fetchCard(withId: identifier) { [weak self] result in
            switch result {
            case .success(let card):
                DispatchQueue.main.async {
                    self?.card = card
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func handleKeyboard(_ notification: Notification) {
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            switch notification.name {
            case UIResponder.keyboardWillShowNotification:
                containerBottomConstraint.constant += value.cgRectValue.height
            case UIResponder.keyboardWillHideNotification:
                containerBottomConstraint.constant = 30
            default:
                return
            }

            UIView.animate(withDuration: 0) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }

    @objc
    private func handleTapGesture() {
        textView.resignFirstResponder()
    }

    @objc
    private func deleteCard() {
        let alert = UIAlertController(title: "Delete \(card.name) card?", message: "You'll lose all your data associated with this card. Deleting a card cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [unowned self] _ in
            APIService.shared.deleteCard(withId: self.identifier, completionHandler: { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        // Calling popToRootViewController(animated:) over popViewController(animated:),
                        // becouse previous view controller in stack fetches data on viewDidLoad()
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        })

        present(alert, animated: true)
    }

    deinit {
        view.removeGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.removeObserver(self)
    }
}

extension CardViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card.labels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: LabelCollectionViewCell.self, for: indexPath)!
        cell.configure(with: card.labels[indexPath.row])

        return cell
    }
}

extension CardViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let string = textView.text as NSString
        let newValue = string.replacingCharacters(in: range, with: text)

        placeholderLabel.isHidden = !newValue.isEmpty

        return newValue.count <= 16384
    }
}

extension CardViewController: CardLabelCollectionViewLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat {

        let string = card.labels[indexPath.row].name as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byClipping

        let size = string.size(withAttributes: [
            .font : UIFont.systemFont(ofSize: 15, weight: .regular),
            .paragraphStyle: paragraphStyle
        ])

        let estimatedWidth = collectionViewLayout.itemWidth

        return size.width > estimatedWidth ? size.width + 10 : estimatedWidth
    }
}
