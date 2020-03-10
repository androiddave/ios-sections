//
// Created by David Scott on 2019-01-02.
// Copyright (c) 2019 jfc. All rights reserved.
//

import Foundation
import Views
import Models

class SectionFavouriteMagazines : Section {


    var magazines = [Magazine]()

    init(collectionView: UICollectionView){
        super.init(collectionView: collectionView,
                loadedItem: CoverText.self,
                loadingItem: LoadingCell.self,
                header: SectionHeaderView.self,
                footer: SingleLineText.self,
                error: ErrorCell.self)
    }


    override func numberOfItems() -> Int {
        if state == .LOADED {
            return min(self.maxItems, magazines.count)
        } else if state == .IDLE {
            return 0
        } else {
            return 1
        }
    }

    override func bindLoadedCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let coverCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverText.reUseId, for: indexPath)
                as! CoverText

        coverCell.label.text = self.magazines[indexPath.row].Name
        coverCell.label.textColor = UIColor.white
        coverCell.loadImage(self.magazines[indexPath.row].getCoverUrlLow(shouldShowCustom: false))
        return coverCell
    }

    override func bindHeader(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeaderView.reUseId, for: indexPath) as! SectionHeaderView

        headerView.setTitle(text: TextUtils.GetText("favourite_magazines"),
                colour: UIColor.white)

        return headerView
    }

    override func bindFooter(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: SingleLineText.reUseId, for: indexPath) as! SingleLineText

        footerView.label.text = TextUtils.GetText("view_more")
        footerView.label.textColor = UIColor.white
        footerView.label.textAlignment = .center

        return footerView
    }

    override func getFooterSize(_ collectionView: UICollectionView, columns: Int?) -> CGSize {
        if magazines.count > self.maxItems {
            return super.getFooterSize(collectionView, columns: columns)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    override func bindLoadingCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reUseId, for: indexPath)
                as! LoadingCell
        cell.load()
        return cell
    }

    override func bindEmptyCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCell.reUseId, for: indexPath) as! ErrorCell
        cell.imageView.image = UIImage(named: "error_favourites", in: Bundle(for: SectionFavouriteMagazines.self), compatibleWith: nil)
        cell.imageView.tintColor = UIColor.gray
        //   cell.delegate = self

        cell.label.text = TextUtils.GetText("plus_favourites_empty")
        cell.label.textColor = UIColor.gray
        cell.button.isHidden = true


        cell.layoutIfNeeded()
        return cell
    }
}
