//
//  ViewController.swift
//  MosaicLayout
//
//  Created by baiwei－mac on 16/12/26.
//  Copyright © 2016年 YuHua. All rights reserved.
//

/*
 1.该项目使用了cocoapods，该工具的安装和使用，作为一个iOS开发人员是需要掌握的。
 2.同时还采用了和OC混编的模式，采用了cocoapods，在需要使用的文件导入第三方即可。
 3.如果是手动创建OC文件，则需要增加一个桥接文件。
 4.如果是拖入OC的第三方，而没有采用cocoapods，也需要增加桥接文件。
 5.如果是第一次使用cocoapods的朋友，请打开xcworkspace文件再运行
 */

import UIKit
import FMMosaicLayout

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)
let YHStatusBarFrame = UIApplication.shared.statusBarFrame


class ViewController: UIViewController {
    
    
    var collectionView: UICollectionView!
    var images = ["back","birds","sunset","waves"]
    let reuseIdentifier = String(describing: CustomCollectionCell.self)
    let reuseHeaderIdentifier = String(describing: CustomHeaderView.self)
    let HeaderFooterHeight: CGFloat = 44
    let ColumnCount = 2
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func setupView() {
        
        let collectionLayout = FMMosaicLayout()
        collectionView = UICollectionView(frame: YHRect, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseHeaderIdentifier)
        view.addSubview(collectionView)
    }
}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionCell
        cell.imageView.image = UIImage(named: images[indexPath.row%4])
        cell.title.text = "第\(indexPath.row+1)个"
        return cell
    }
    
    //设置分区头和weight
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewHF = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! CustomHeaderView
        viewHF.title.text = kind == UICollectionElementKindSectionHeader ? "SECTION \(indexPath.section+1)" : "OVER SECTION \(indexPath.section+1)"
        return viewHF
    }
}



extension ViewController: FMMosaicLayoutDelegate {
    //列
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return ColumnCount
    }
    
    //item大小
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, mosaicCellSizeForItemAt indexPath: IndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSize.big : FMMosaicCellSize.small
    }
    
    //分区内边距
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    //分区间隔
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //头高
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderFooterHeight
    }

    //尾高
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForFooterInSection section: Int) -> CGFloat {
        return HeaderFooterHeight
    }

    //控制分区头尾是否在collectionview之上
    func headerShouldOverlayContent(in collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
    
    func footerShouldOverlayContent(in collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
}


