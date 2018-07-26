//
//  AllNodesView.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

fileprivate let padding: CGFloat = 8

class AllNodesView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: FlowLayout!
    let indicator = ARIndicator(firstColor: UIColor.fromHex(string: "#1B9AAA"), secondColor: UIColor.fromHex(string: "#06D6A0"), thirdColor: UIColor.fromHex(string: "#E84855"))
    
    static let shared = Bundle.main.loadNibNamed(Global.Views.allNodesView, owner: nil, options: nil)?.first as! AllNodesView
    var data: Array<NodeGroupModel> = []
    var labelWidth = [[CGFloat]]()

    override func awakeFromNib() {
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        collectionView.layer.shouldRasterize = true
        collectionView.layer.rasterizationScale = UIScreen.main.scale
        let cellNib = UINib(nibName: "AllNodesCollectionViewCell", bundle: nil)
        let titleCellNib = UINib(nibName: "AllNodesCollectionReusableView", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Global.Cells.allNodesCell)
        collectionView.register(titleCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Global.Cells.allNodesTitleCell)
        collectionView.contentInset = UIEdgeInsetsMake(10, padding, 0, padding)
        self.flowLayout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding)
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 50, 0)
        if #available(iOS 9.0, *) {
            self.flowLayout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
//        self.flowLayout.headerReferenceSize = CGSize(width: Global.Constants.screenWidth, height: 50)
        
        indicator.center = CGPoint(x: Global.Constants.screenWidth / 2, y: Global.Constants.screenHeight / 2)
        indicator.state = .running
        self.addSubview(indicator)
        
        NetworkManager.shared.getAllNodes(success: { (res) in
            for group in res {
                var arr = [CGFloat]()
                for node in group.list {
                    let rect = (node.name as NSString).boundingRect(with: CGSize(width: 400, height: Global.Config.unitNodeCellHeight),
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [NSAttributedStringKey.font: UIFont(name: "PingFang HK", size: 16) ?? UIFont.systemFont(ofSize: 16)],
                                                          context: nil)
                    arr.append(rect.width)
                }
                self.labelWidth.append(arr)
            }
            self.data = res
            self.collectionView.reloadData()
            self.indicator.state = .stopping
        }) { (error) in
            self.indicator.state = .stopping
            // TODO: add toast
        }
    }

}

extension AllNodesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Global.Cells.allNodesTitleCell, for: indexPath) as! AllNodesCollectionReusableView
        cell.setData(title: data[indexPath.section].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Global.Cells.allNodesCell, for: indexPath) as! AllNodesCollectionViewCell
        cell.setData(name: data[indexPath.section].list[indexPath.row].name, width: labelWidth[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: labelWidth[indexPath.section][indexPath.row] + Global.Config.unitNodeCellPadding + Global.Config.unitNodeCellPadding, height: Global.Config.unitNodeCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Global.Notifications.kUnitNodeSelectChanged,
                                        object: nil,
                                        userInfo: [Global.Keys.kUnitNode: data[indexPath.section].list[indexPath.row]])
    }
    
    
    
}

// MARK: FlowLayout
class FlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        guard attributesForElementsInRect != nil else {
            return attributesForElementsInRect
        }
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        // use a value to keep track of left margin
        var leftMargin: CGFloat = 0.0
        for attributes in attributesForElementsInRect! {
            let refAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else if leftMargin + refAttributes.frame.width > Global.Constants.screenWidth - padding - padding {
                leftMargin = self.sectionInset.left
                refAttributes.frame.origin.x = leftMargin
            } else {
                refAttributes.frame.origin.x = leftMargin
            }
            leftMargin += refAttributes.frame.size.width + padding
            newAttributesForElementsInRect.append(refAttributes)
        }
        return newAttributesForElementsInRect
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}




