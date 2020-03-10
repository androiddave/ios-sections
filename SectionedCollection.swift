//
// Created by David Scott on 2019-01-02.
// Copyright (c) 2019 jfc. All rights reserved.
//

import Foundation
import UIKit

// Work in progress of a library for handling multi section collection views
public class SectionedCollection {

    public init(){

    }

    public var sections = [Int: Section]()

    public var increaseHeaderSize = true

    public func numberOfItem() -> Int{
        return sections.count
    }


    public func numberOfItemsForSection(_ section: Int) -> Int {
        return sections[section]?.numberOfItems() ?? 0
    }

    public func cellForItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sections[indexPath.section]?.bindView(collectionView, indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }

    public func bindSupplementaryView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath,
                                      action: (() -> Void)? = nil)  -> UICollectionReusableView {
        let supplementaryView = sections[indexPath.section]?.bindSupplementaryView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) ?? UICollectionReusableView()
        if action != nil {
            supplementaryView.addTapGestureRecognizer(action: action)
        }
        return supplementaryView
    }

    public func getItemSize(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section]?.getItemSize(collectionView, columns: sections[indexPath.section]?.columns ?? 1) ?? CGSize(width: 0, height: 0)
    }

    public func getHeaderSize(_ collectionView: UICollectionView, section: Int) -> CGSize {

        var headerSize = sections[section]?.getHeaderSize(collectionView, columns: 1) ?? CGSize(width: 0, height: 0)

        if section > 0 && increaseHeaderSize {
            headerSize.height = CGFloat(headerSize.height * 1.5)
        }

        return headerSize

    }

    public func getFooterSize(_ collectionView: UICollectionView, section: Int) -> CGSize {
        return sections[section]?.getFooterSize(collectionView, columns: 1) ?? CGSize(width: 0, height: 0)

    }

}
