//
//  CardLabelCollectionViewLayout.swift
//  trello
//
//  Created by e.vanags on 27/04/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import UIKit

public protocol CardLabelCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

final public class CardLabelCollectionViewLayout: UICollectionViewLayout {

    private enum DisplayMode {
        case unspecified
        case compact
        case expanded
    }

    public weak var delegate: CardLabelCollectionViewLayoutDelegate!

    private var verticalContentInsets: CGFloat {
        guard let collectionView = collectionView else {
            return .zero
        }

        return collectionView.contentInset.top + collectionView.contentInset.bottom
    }

    private var horizontalContentInsets: CGFloat {
        guard let collectionView = collectionView else {
            return .zero
        }

        return collectionView.contentInset.left + collectionView.contentInset.right
    }

    public var maxHeight: CGFloat {
        return verticalContentInsets + itemHeight * 2 + itemSpacing * 3
    }

    public var minHeight: CGFloat {
        return verticalContentInsets + itemHeight + itemSpacing
    }

    public var itemWidth: CGFloat = 50

    public var itemHeight: CGFloat = 30

    public var itemSpacing: CGFloat = 5

    private var displayMode: DisplayMode {
        guard let collectionView = collectionView else {
            return .unspecified
        }

        let itemCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        let spacingCount = itemCount - 1
        let estimatedWidth = itemCount * itemWidth + spacingCount * itemSpacing

        return estimatedWidth > collectionView.bounds.width ? .expanded : .compact
    }

    private var numberOfRows: Int {
        switch displayMode {
        case .compact:
            return 1
        case .expanded:
            return 2
        case .unspecified:
            return .zero
        }
    }

    private var layoutAttributes = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat {
        switch displayMode {
        case .compact:
            return minHeight
        case .expanded:
            return maxHeight
        default:
            return .zero
        }
    }

    private var contentWidth: CGFloat = .zero

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth,
                      height: contentHeight - verticalContentInsets)
    }
}

extension CardLabelCollectionViewLayout {
    override public func prepare() {
        guard layoutAttributes.isEmpty, let collectionView = collectionView else {
            return
        }

        var row = 0
        var xOffset = [CGFloat](repeating: 0, count: numberOfRows)

        var yOffset = [CGFloat]()
        for row in 0 ..< numberOfRows {
            yOffset.append(CGFloat(row) * (itemHeight + itemSpacing))
        }

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let itemWidth = delegate.collectionView(collectionView, widthForCellAtIndexPath: indexPath)
            let width = itemSpacing + itemWidth
            let height = itemSpacing * 2 + itemHeight
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: height)
            let insetFrame = frame.insetBy(dx: itemSpacing / 2, dy: itemSpacing)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributes.append(attributes)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] += width

            row = row < (numberOfRows - 1) ? (row + 1) : 0
        }
    }
}

extension CardLabelCollectionViewLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
}

extension CardLabelCollectionViewLayout {
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}
