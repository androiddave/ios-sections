//
// Created by David Scott on 2019-01-11.
// Copyright (c) 2019 jfc. All rights reserved.
//

import Foundation
import Reachability
import MaterialComponents.MaterialSnackbar

open class BaseSectionedViewController : UIViewController,
        UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet public weak var collectionView: UICollectionView!

    public let sections = SectionedCollection()

    public let refreshControl = UIRefreshControl()


    public var hasLoaded = false
   
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasLoaded {

            setupRefresh()

            self.collectionView.layoutIfNeeded()
            
            setupSections()

            loadData(forceUpdate: false)

            self.hasLoaded = true
        } else {
            self.resizeSections()
        }

    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }


    open func resizeSections(){

    }

    open func setupRefresh(){

        refreshControl.tintColor = UIColor.white

        let title = NSLocalizedString("PullToRefresh", bundle: Bundle(for: BaseSectionedViewController.self), comment: "")
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        refreshControl.addTarget(self,
                action: #selector(refresh),
                for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    open func setupSections(){
        fatalError("Must override 'loadData()'")
    }

    @objc public func refresh(){
        self.loadData(forceUpdate: true)
    }

    open func loadData(forceUpdate: Bool){
        fatalError("Must override 'loadData()'")
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections.numberOfItemsForSection(section)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.numberOfItem()
    }


    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.sections.cellForItem(collectionView: collectionView, indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding = PmSizing.DefaultPadding()
        return UIEdgeInsets(top:padding, left:padding, bottom:padding, right:padding)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PmSizing.DefaultPadding()
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PmSizing.DefaultPadding()
    }


    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sections.getItemSize(collectionView, indexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.sections.getHeaderSize(collectionView, section: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.sections.getFooterSize(collectionView, section: section)
    }



    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var action: (() -> Void)? = nil

        if kind == UICollectionView.elementKindSectionFooter {
            action = {
                self.onFooterPress(indexPath: indexPath)
            }
        }
        return self.sections.bindSupplementaryView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath, action: action)
    }

    @objc open func onFooterPress(indexPath: IndexPath){

    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fatalError("Must be overridden")
    }


    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Have the collection view re-layout its cells.
        coordinator.animate(
            alongsideTransition: { _ in self.collectionView?.collectionViewLayout.invalidateLayout() },
                completion: { _ in }
        )
    }

}
