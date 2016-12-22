//
//  CirCleLayout.swift
//  CustomCollectionLayout
//
//  Created by baiwei－mac on 16/12/22.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class CirCleLayout: UICollectionViewFlowLayout {

    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    //圆心
    var center = CGPoint(x: 0, y: 0)
    //半径
    var radius: CGFloat = 0
    var totalNum = 0
    
    
    override func prepare() {
        
        super.prepare()
        //初始化数据
        totalNum = collectionView!.numberOfItems(inSection: 0)
        //计算前需要清零
        layoutAttributes = []
        center = CGPoint(x: collectionView!.bounds.width * 0.5, y: collectionView!.bounds.height * 0.5)
        radius = min(collectionView!.bounds.width, collectionView!.bounds.height) / 3
        
        var indexPath: IndexPath
        for index in 0..<totalNum {
            indexPath = IndexPath(row: index, section: 0)
            layoutAttributes.append(layoutAttributesForItem(at: indexPath)!)
        }
    }
    
    
    //collectionView不能滚动，旋转时触发，返回true，重新计算布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    
    //该方法建议重写
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = CGSize(width: 60, height: 60)
        let angle = 2 * CGFloat(M_PI) * CGFloat(indexPath.row) / CGFloat(totalNum)
        attributes.center = CGPoint(x: center.x + radius*cos(angle), y: center.y + radius*sin(angle))
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView!.bounds.size
    }
}
