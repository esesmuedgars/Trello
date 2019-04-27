//
//  CardLabelCollectionView.swift
//  trello
//
//  Created by e.vanags on 27/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

final public class CardLabelCollectionView: UICollectionView {

    public override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    private var verticalContentInsets: CGFloat {
        return contentInset.top + contentInset.bottom
    }

    private var horizontalContentInsets: CGFloat {
        return contentInset.left + contentInset.right
    }

    public override var intrinsicContentSize: CGSize {
        let contentSize = collectionViewLayout.collectionViewContentSize

        return CGSize(width: contentSize.width + horizontalContentInsets,
                      height: contentSize.height + verticalContentInsets)
    }
}
