//
//  ViewController.swift
//  SortableCollectionView
//
//  Created by baiwei－mac on 16/12/21.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width


class ViewController: UIViewController {
    
    
    var collectionView: SortableCollectionView!
    var timer: Timer?
    let reuseIdentifier = String(describing: UICollectionViewCell.self)
    
    var data = [UIColor]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupView() {
        
        //生成41个cell
        for _ in 0...40 {
            data.append(UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0))
        }
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical//滚动方向
        collectionLayout.itemSize = CGSize(width: (YHWidth-40)/3, height: (YHWidth-40)/3)//cell大小
        collectionLayout.minimumLineSpacing = 5//上下间隔
        collectionLayout.minimumInteritemSpacing = 5//左右间隔
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)//section边界
        collectionView = SortableCollectionView(frame: YHRect, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.sortableDelegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
    }

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, SortableCollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        cell.backgroundColor = data[indexPath.row] 
        return cell
    }
    
    //改变数据
    func exchangeDataSource(fromIndex: IndexPath, toIndex: IndexPath) {
        let temp = data[fromIndex.row]
        data[fromIndex.row] = data[toIndex.row]
        data[toIndex.row] = temp
    }
    
    //开始拖动
    func beginDragAndInitDragCell(collectionView: SortableCollectionView, dragCell: UIView) {
        dragCell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        dragCell.backgroundColor = .lightGray
    }
    
    //拖动结束
    func endDragAndResetDragCell(collectionView: SortableCollectionView, dragCell: UIView) {
        dragCell.transform = CGAffineTransform(scaleX: 1, y: 1)
        dragCell.backgroundColor = .white
    }
}


