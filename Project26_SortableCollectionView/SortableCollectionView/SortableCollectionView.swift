//
//  SortableCollectionView.swift
//  SortableCollectionView
//
//  Created by baiwei－mac on 16/12/21.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

//声明一个协议
@objc protocol SortableCollectionViewDelegate {
    
    @objc optional func beginDragAndInitDragCell(collectionView: SortableCollectionView, dragCell:  UIView)
    
    @objc optional func endDragAndResetDragCell(collectionView: SortableCollectionView, dragCell: UIView)
    
    @objc optional func endDragAndOperateRealCell(collectionView: SortableCollectionView, realCell: UICollectionViewCell, isMoved: Bool)
    
    @objc optional func exchangeDataSource(fromIndex: IndexPath, toIndex: IndexPath)
}


class SortableCollectionView: UICollectionView {

    weak var sortableDelegate: SortableCollectionViewDelegate?
    
    var dragView: UIView!//快照
    var originCell: UICollectionViewCell?//移动的cell
    var timer: Timer?
    
    var fromIndex: IndexPath!
    var toIndex: IndexPath?
    var isMovement = false
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(panHandler(sender:)))
        addGestureRecognizer(pan)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    //手势触发
    func panHandler(sender: UILongPressGestureRecognizer) {
        
        //手势点在collectionView的位置
        let collectionViewPoint = sender.location(in: self)
        //手势点在父view的位置
        let viewPoint = sender.location(in: superview)
        //手势按下
        if sender.state == .began {
            //获得手势点的cell
            if let index = indexPathForItem(at: collectionViewPoint), let originCell = cellForItem(at: index) {
                beginMoveItemAtIndex(index: index, cell: originCell ,viewCenter: viewPoint)
            }
        }
        //手势改变
        else if sender.state == .changed {
            updateMoveItem(viewPoint: viewPoint, collectionViewPoint: collectionViewPoint)
        }
        //手势抬起
        else if sender.state == .ended {
            endMoveItem()
        }
        
    }
    
}


extension SortableCollectionView {
    
    func beginMoveItemAtIndex(index: IndexPath, cell: UICollectionViewCell, viewCenter: CGPoint) {
        
        fromIndex = index
        originCell = cell
        cell.isHidden = true
        //如果遵循了nscopying协议，并返回了副本的，可以用copy来获得view的副本
        if let copyable = originCell as? NSCopying {
            dragView = copyable.copy(with: nil) as! UIView
        }else {
            //该方法在模拟器里面无法获得快照，真机是可以的
            dragView = cell.snapshotView(afterScreenUpdates: false)
        }
        //将快照添加到父view
        dragView.center = viewCenter
        superview?.addSubview(dragView)
        dragView.autoresizesSubviews = false
        //告诉代理开始拖动
        sortableDelegate?.beginDragAndInitDragCell?(collectionView: self, dragCell: dragView)
        bringSubview(toFront: dragView)
        
    }
    
    
    func updateMoveItem(viewPoint: CGPoint, collectionViewPoint: CGPoint) {
        
        //移动快照位置
        dragView.center = viewPoint
        //移动item位置
        moveItemToPoint(collectionViewPoint: collectionViewPoint)
        scrollAtEdge()
        
    }
    
    
    func endMoveItem() {
        
        //移动结束
        timer?.invalidate()
        timer = nil
        if let origin = originCell {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            let rect = origin.frame
                            self.sortableDelegate?.endDragAndResetDragCell?(collectionView: self, dragCell: self.dragView)
                            self.dragView.frame = CGRect(x: rect.origin.x, y: rect.origin.y-self.contentOffset.y, width: rect.width, height: rect.height)
                }, completion: { (finish) in
                    self.dragView.removeFromSuperview()
                    origin.isHidden = false
                    var isMoved = false
                    if let toIndex = self.toIndex {
                        self.sortableDelegate?.exchangeDataSource?(fromIndex: self.fromIndex, toIndex: toIndex)
                        isMoved = true
                    }
                    self.sortableDelegate?.endDragAndOperateRealCell?(collectionView: self, realCell: origin, isMoved: isMoved)
            })
        }
        
    }
    
    
    func moveItemToPoint(collectionViewPoint: CGPoint) {
        
        if let index = indexPathForItem(at: collectionViewPoint),let originCell = self.originCell {
            let cell = cellForItem(at: index)
            if cell != originCell {
                //由于该方法的原因，所以本项目的移动方式只适用于iOS8以上系统
                self.performBatchUpdates({
                    if let fromIndex = self.indexPath(for: originCell) {
                        self.moveItem(at: fromIndex, to: index)
                    }
                }){
                    success in
                    if success {
                        self.toIndex = index
                    }
                }
            }
        }

    }
    
    
    func scrollAtEdge() {
        
        let pinTop = dragView.frame.origin.y
        let pinBottom = self.frame.height - (dragView.frame.origin.y + dragView.frame.height)
        var speed:CGFloat = 0
        var isTop:Bool = true
        if pinTop < 0 {
            speed = -pinTop
            isTop = true
        } else if pinBottom < 0 {
            speed = -pinBottom
            isTop = false
        } else {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        if let originTimer = self.timer,let originSpeed = (originTimer.userInfo as? [String:AnyObject])?["speed"] as? CGFloat{
            if abs(speed - originSpeed) > 10 {
                originTimer.invalidate()
                NSLog("speed:\(speed)")
                let timer = Timer(timeInterval: 1/60.0, target: self, selector: #selector(autoScroll(timer:)), userInfo: ["top":isTop,"speed": speed] , repeats: true)
                self.timer = timer
                RunLoop.main.add(timer, forMode: .commonModes)
            }
        } else {
            let timer = Timer(timeInterval: 1/60.0, target: self, selector: #selector(autoScroll(timer:)), userInfo: ["top":isTop,"speed": speed] , repeats: true)
            self.timer = timer
            RunLoop.main.add(timer, forMode: .commonModes)
        }
        
    }
    
    
    func autoScroll(timer: Timer) {
        
        if let userInfo = timer.userInfo as? [String:AnyObject] {
            if let top =  userInfo["top"] as? Bool,let speed = userInfo["speed"] as? CGFloat {
                let offset = speed / 5
                let contentOffset = self.contentOffset
                if top {
                    self.contentOffset.y -= offset
                    self.contentOffset.y = self.contentOffset.y < 0 ? 0 : self.contentOffset.y
                }else {
                    self.contentOffset.y += offset
                    self.contentOffset.y = self.contentOffset.y > self.contentSize.height - self.frame.height ? self.contentSize.height - self.frame.height  : self.contentOffset.y
                }
                let point = CGPoint(x: dragView.center.x, y: dragView.center.y + contentOffset.y)
                self.moveItemToPoint(collectionViewPoint: point)
            }
        }
        
    }
    
}

