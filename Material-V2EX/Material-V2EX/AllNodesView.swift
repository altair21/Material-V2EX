//
//  AllNodesView.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class AllNodesView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: FlowLayout!
    
    static let shared = Bundle.main.loadNibNamed(Global.Views.allNodesView, owner: nil, options: nil)?.first as! AllNodesView
    var sizingCell: AllNodesCollectionViewCell?
    var data: Array<NodeGroupModel>?

    let TAGS = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    
    override func awakeFromNib() {
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        
        let cellNib = UINib(nibName: "AllNodesCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Global.Cells.allNodesCell)
        collectionView.contentInset = UIEdgeInsetsMake(10, 8, 0, 8)
        self.sizingCell = cellNib.instantiate(withOwner: nil, options: nil).first as? AllNodesCollectionViewCell
        self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
    }

}

extension AllNodesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TAGS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Global.Cells.allNodesCell, for: indexPath) as! AllNodesCollectionViewCell
        cell.setData(name: TAGS[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.sizingCell?.setData(name: TAGS[indexPath.row])
        return (self.sizingCell?.systemLayoutSizeFitting(UILayoutFittingCompressedSize))!
    }
    
}

// MARK: FlowLayout
class FlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        // use a value to keep track of left margin
        var leftMargin: CGFloat = 0.0
        for attributes in attributesForElementsInRect! {
            let refAttributes = attributes
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                refAttributes.frame.origin.x = leftMargin
            }
            leftMargin += refAttributes.frame.size.width + 8
            newAttributesForElementsInRect.append(refAttributes)
        }
        return newAttributesForElementsInRect
    }
}




