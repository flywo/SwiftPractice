//
//  LineLayout.swift
//  CustomCollectionLayout
//
//  Created by baiwei－mac on 16/12/22.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

/*自定义layout
 1.UICollectionViewLayoutAttributes:该属性是所有cell的frame都由该属性的相关设置完成的。修改该属性即修改了cell相关属性。
 
 2.UICollectionViewFlowLayout:完成collectionView的布局需要设置该属性。
 
 3.prepare():需要重新布局前，都会调用该方法，一般重写该方法做一些准备工作，比如计算好所有cell布局，并且缓存下来，需要的时候直接取即可
 
 4.layoutAttributesForElementsInRect(rect: CGRect):该方法紧随prepare()后调用，用于获取rect范围内所有cell的布局。该方法必须重写，提供相应rect范围内cell的所有布局的UICollectionViewLayoutAttributes，如果已经计算好，就直接返回。如果只返回rect范围内的cell的布局，而不是全部cell的布局，需要设置一下
 
 5.shouldInvalidateLayoutForBoundsChange(newBounds: CGRect)：当collectionView的bounds变化时会调用该方法。如果布局是会时刻变化的，需要在滚动过程中重新布局，需要返回true，否则false
 *返回true的时候，collectionview的layout设置为invalidate，将会使collectionview重新调用上面的preparelayout()方法重新获得布局
 *同时，当屏幕旋转的时候，collectionview的bounds也会调用该方法，如果设置为false，不会达到屏幕适配效果
 *collectionview执行delete,insert,reload等，不会调用该方法，会调用prepare()重新获得布局
 
 6.需要设置collectionview的滚动范围collectionviewcontensize()，自定义时，必须重写该方法，返回正确的滚动范围
 
 7.如下方法也建议重写：
 自定义cell布局的时候重写
 public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
 自定义SupplementaryView的时候重写
 public func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
 自定义DecorationView的时候重写
 public func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
 
 8.public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint：这个方法是当collectionView将停止滚动的时候调用, 我们可以重写它来实现, collectionView停在指定的位置(比如照片浏览的时候, 你可以通过这个实现居中显示照片)
 */

class LineLayout: UICollectionViewFlowLayout {

    
    //缓存布局
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    
    
    override func prepare() {
        
        super.prepare()
        scrollDirection = .horizontal   
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let superLayoutAttributes = super.layoutAttributesForElements(in: rect)!
        let collectionViewCenterX = collectionView!.bounds.width * 0.5
        
        superLayoutAttributes.forEach { (attributes) in
            let copyLayout = attributes.copy() as! UICollectionViewLayoutAttributes
            //中心点横向距离差
            let deltaX = abs(collectionViewCenterX - copyLayout.center.x + collectionView!.contentOffset.x)
            //计算屏幕内的cell的transform
            if deltaX < collectionView!.bounds.width/2 {
                let scale = 1 - deltaX / collectionViewCenterX
                copyLayout.transform = CGAffineTransform(scaleX: scale, y: scale)
            }else {
                copyLayout.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            layoutAttributes.append(copyLayout)
        }
        return layoutAttributes
    }
    
    
    //设置为true，滚动的时候实时更新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
