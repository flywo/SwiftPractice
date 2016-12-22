//
//  ShowViewController.swift
//  CustomCollectionLayout
//
//  Created by baiwei－mac on 16/12/22.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    
    /*风格：
     1.line
     2.circle
     3.waterfall
     */
    var style: String!
    var collectionView: UICollectionView!
    var reuseIdentifier = String(describing: UICollectionViewCell.self)
    var cellCount = 0
    
    var cellHeight = [CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setupView() {
        
        edgesForExtendedLayout = []
        collectionView = UICollectionView(frame: YHNoNavRect, collectionViewLayout: UICollectionViewLayout())
        switch style {
        case "line":
            setLineLayout()
            cellCount = 50
        case "circle":
            setCircleLayout()
            cellCount = 10
        default:
            setWaterFallLayout()
            cellCount = 100
            for _ in 0..<self.cellCount {
                cellHeight.append(CGFloat(arc4random() % 150 + 40))
            }
        }
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    
    func setWaterFallLayout() {
        let layout = WaterFallLayout()
        layout.delegate = self
        layout.numberOfColums = 4
        collectionView.collectionViewLayout = layout
    }
    
    
    func setCircleLayout() {
        let layout = CirCleLayout()
        collectionView.collectionViewLayout = layout
    }
    
    
    func setLineLayout() {
        let layout = LineLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
    }
}


extension ShowViewController: UICollectionViewDataSource, UICollectionViewDelegate ,CustomWaterFallLayoutDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        return cell
    }
    
    func heightForItemAtIndexPath(indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}

