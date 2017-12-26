//
//  ViewController.swift
//  LZYWaterfall
//
//  Created by LZY on 17/11/14.
//  Copyright © 2017年 LZY. All rights reserved.
//

import UIKit
private let kMarager: CGFloat = 10
private let kCellID: String = "kCellID"
private let kScrrenW: CGFloat = UIScreen.main.bounds.size.width
//数据源
private var tempDataSoucre: [String] = ["1", "2", "3", "1", "2", "3", "1", "2", "3","1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3","1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3","1", "2", "3", "1", "2", "3"]
class ViewController: UIViewController {
    
    fileprivate lazy var collection: UICollectionView = {
        
        //1.创建LZY_FlowLayout
        let flowLayout: LZY_FlowLayout = LZY_FlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumLineSpacing = kMarager
        flowLayout.minimumInteritemSpacing = kMarager
        flowLayout.sectionInset = UIEdgeInsetsMake(kMarager, kMarager, kMarager, kMarager)
        flowLayout.dataSource = self
        
        //2.创建UICollectionView
        let collection: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.white
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collection.dataSource = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加集合视图
        view.addSubview(collection)
    }


}
//代理(UICollectionView)
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempDataSoucre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
        
        return cell
    }
}

//代理(LZY_FlowLayout)
extension ViewController: LZY_FlowLayoutDelegate {
    //每个cell的高度
    func itemHeight(_ flowlayout: LZY_FlowLayout, indexPath: IndexPath) -> CGFloat {
        return (indexPath.item % 2 == 0) ? kScrrenW * 2 / 3 : kScrrenW * 0.5
    }
    
    //显示多少列
    func numberCols(_ flowlayout: LZY_FlowLayout) -> Int {
        return 4
    }
}

