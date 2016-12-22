//
//  WaterFallLayout.swift
//  CustomCollectionLayout
//
//  Created by baiwei－mac on 16/12/22.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit


protocol CustomWaterFallLayoutDelegate: NSObjectProtocol {
    
    //设置cell高度
    func heightForItemAtIndexPath(indexPath: IndexPath) -> CGFloat
}


class WaterFallLayout: UICollectionViewFlowLayout {

    //列
    var numberOfColums = 0 {
        didSet {
            for _ in 0..<numberOfColums {
                maxYOfColums.append(0)
            }
        }
    }
    //间隙
    var itemSpace: CGFloat = 5
    weak var delegate: CustomWaterFallLayoutDelegate?
    //缓存
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var maxYOfColums = [CGFloat]()
    private var oldScreenWidth: CGFloat = 0
    
    
    override func prepare() {
        
        super.prepare()
        layoutAttributes = computeLayoutAttributes()
        oldScreenWidth = YHWidth
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    
    //必须重写
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxYOfColums.max()!)
    }
    
    
    //旋转屏幕后刷新视图
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != oldScreenWidth
    }
    
    
    // 计算所有的UICollectionViewLayoutAttributes
    func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        
        let totalNums = collectionView!.numberOfItems(inSection: 0)
        let width = (collectionView!.bounds.width - itemSpace * CGFloat(numberOfColums + 1)) / CGFloat(numberOfColums)
        
        var x: CGFloat
        var y: CGFloat
        var height: CGFloat
        var currentColum: Int
        var indexPath: IndexPath
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        guard let unwapDelegate = delegate else {
            assert(false, "需要设置代理")
            return attributesArr
        }
        
        for index in 0..<numberOfColums {
            self.maxYOfColums[index] = 0
        }
        for currentIndex in 0..<totalNums {
            indexPath = IndexPath(item: currentIndex, section: 0)
            
            height = unwapDelegate.heightForItemAtIndexPath(indexPath: indexPath)
            
            if currentIndex < numberOfColums {// 第一行直接添加到当前的列
                currentColum = currentIndex
                
            } else {// 其他行添加到最短的那一列
                // 这里使用!会得到期望的值
                let minMaxY = maxYOfColums.min()!
                currentColum = maxYOfColums.index(of: minMaxY)!
            }
            //            currentColum = currentIndex % numberOfColums
            x = itemSpace + CGFloat(currentColum) * (width + itemSpace)
            // 每个cell的y
            y = itemSpace + maxYOfColums[currentColum]
            // 记录每一列的最后一个cell的最大Y
            maxYOfColums[currentColum] = y + height
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 设置用于瀑布流效果的attributes的frame
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            
            attributesArr.append(attributes)
        }
        return attributesArr
    }
}
