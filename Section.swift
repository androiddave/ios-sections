//
// Created by David Scott on 2019-01-02.
// Copyright (c) 2019 jfc. All rights reserved.
//

import Foundation
import UIKit

// Work in progress of section for a multi section collectionview
open class Section {

    public enum State {
        case IDLE
        case LOADING
        case LOADED
        case FAILED
        case EMPTY
    }

    public var state: State = .IDLE

    public var showHeader = true

    public var showFooter = true

    public var maxItems = 4

    public var columns = 2

    public var sizeFactor = 1.0

    let loadedItem: BaseCell.Type
    let loadingItem: BaseCell.Type?
    let header: BaseCell.Type?
    let footer: BaseCell.Type?
    let error: BaseCell.Type?


    public init(collectionView: UICollectionView,
         loadedItem: BaseCell.Type,
         loadingItem: BaseCell.Type? = nil,
         header: BaseCell.Type? = nil,
         footer: BaseCell.Type? = nil,
         error: BaseCell.Type? = nil){

        self.loadedItem = loadedItem
        self.loadingItem = loadingItem
        self.header = header
        self.footer = footer
        self.error = error


        self.registerNibs(collectionView)
    }

    private func registerNibs(_ collectionView: UICollectionView){
        loadedItem.RegisterNib(collectionView)
        loadingItem?.RegisterNib(collectionView)
        header?.RegisterNib(collectionView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        footer?.RegisterNib(collectionView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        error?.RegisterNib(collectionView)
    }




    public func bindView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .LOADED:
            return bindLoadedCell(collectionView, indexPath: indexPath)
        case .LOADING:
            if(loadingItem != nil) {
                return bindLoadingCell(collectionView, indexPath: indexPath)
            }
        case .EMPTY, .FAILED:
            if(error != nil){
                return bindEmptyCell(collectionView, indexPath: indexPath)
            }
        default:
            return UICollectionViewCell()
        }

        return UICollectionViewCell()
    }


    public func bindSupplementaryView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath)  -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return bindHeader(collectionView, at: indexPath)
        } else if kind == UICollectionView.elementKindSectionFooter {
            return bindFooter(collectionView, at: indexPath)
        }

        return UICollectionReusableView()
    }

    open func getItemSize(_ collectionView: UICollectionView, columns: Int?) -> CGSize {
        switch state {
        case .LOADED:
            return loadedItem.GetSize(collectionView, columns: columns, sizeFactor: self.sizeFactor)
        case .LOADING:
            return loadingItem?.GetSize(collectionView, columns: columns, sizeFactor: 1.0) ?? CGSize(width: 0, height: 0)
        case .EMPTY:
            return error?.GetSize(collectionView, columns: columns, sizeFactor: 1.0) ?? CGSize(width: 0, height: 0)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    public func getHeaderSize(_ collectionView: UICollectionView, columns: Int?, first: Bool = false) -> CGSize {
        if header != nil && showHeader {
            return header?.GetSize(collectionView, columns: columns, sizeFactor: 1.0) ?? CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }


    open func getFooterSize(_ collectionView: UICollectionView, columns: Int?) -> CGSize {
        if showFooter {
            return footer?.GetSize(collectionView, columns: columns, sizeFactor: 1.0) ?? CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }




    open func numberOfItems() -> Int {
        fatalError("Section needs to implement 'numberOfItems()' method.")
    }

    open func bindLoadedCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func bindHeader(_ collectionView: UICollectionView, at indexPath: IndexPath)  -> UICollectionReusableView {
        return UICollectionReusableView()
    }


    open func bindFooter(_ collectionView: UICollectionView, at indexPath: IndexPath)  -> UICollectionReusableView {
        return UICollectionReusableView()
    }

    open func bindLoadingCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func bindEmptyCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }







}
