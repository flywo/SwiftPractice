//
//  ViewController.swift
//  PictureBrowse
//
//  Created by baiwei－mac on 16/12/5.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

let ItemWidth = YHWidth-40.0
let ItemHeight = YHHeight/3.0

class ViewController: UIViewController {
    
    let backgroundImageView = UIImageView(frame: YHRect)
    var collectionView: UICollectionView!
    let data = CollectionModel.createInterests()
    let reuseIdentifier = "CollectionCell"
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        backgroundImageView.image = UIImage(named: "blue")
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal//滚动方向
        collectionLayout.itemSize = CGSize(width: ItemWidth, height: ItemHeight)//cell大小
        collectionLayout.minimumLineSpacing = 20//上下间隔
        collectionLayout.minimumInteritemSpacing = 20//左右间隔
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)//section边界
        collectionView = UICollectionView(frame: CGRect(x: 0.0, y: (YHHeight-ItemHeight)/2, width: YHWidth, height: ItemHeight), collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView .register(CollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        visualEffectView.frame = YHRect
        
        view.addSubview(backgroundImageView)
        view.addSubview(visualEffectView)
        view.addSubview(collectionView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*扩展ViewController支持协议*/
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell
        
        cell.data = self.data[indexPath.row]
        
        return cell
    }
}
