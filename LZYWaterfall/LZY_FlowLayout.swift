//
//  LZY_FlowLayout.swift
//  LZYWaterfall
//
//  Created by LZY on 17/11/14.
//  Copyright © 2017年 LZY. All rights reserved.
//

import UIKit

@objc protocol LZY_FlowLayoutDelegate: class {
    //展示多少列
    @objc optional func numberCols(_ flowlayout: LZY_FlowLayout) -> Int
    
    //item的高度
    func itemHeight(_ flowlayout: LZY_FlowLayout, indexPath: IndexPath) -> CGFloat
}

class LZY_FlowLayout: UICollectionViewFlowLayout {
    
    //代理
    weak var dataSource: LZY_FlowLayoutDelegate?
    
    
    //存放item的高度
    fileprivate lazy var totlaItemHs: [CGFloat] = {
        let cols = self.dataSource?.numberCols?(self) ?? 2
        return Array(repeating: self.sectionInset.top, count: cols)
    }()
    
    //存放所有的item元素
    fileprivate lazy var items: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    //最大高度
    fileprivate var maxH: CGFloat = 0
    //计算item的初始位置
    fileprivate var startIndex = 0
    

}
//扩展
extension LZY_FlowLayout {
    //1.准备
    override func prepare() {
        super.prepare()
        
        //列数
        let cols = dataSource?.numberCols?(self) ?? 2
        
        //1.获取所有的item
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //2.计算items的frame
        let attributesW: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in startIndex..<itemCount {
            //获取indexPath
            let indexPath = IndexPath(item: i, section: 0)
            
            //获取attributes
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            //最小的高度
            let minH = totlaItemHs.min()!
            let indexObject = totlaItemHs.index(of: minH)!
            
            //计算frame
            let attributesH: CGFloat = dataSource?.itemHeight(self, indexPath: indexPath) ?? 100
            let attributesX: CGFloat = sectionInset.left + CGFloat(indexObject) * (attributesW + minimumInteritemSpacing)
            let attributesY: CGFloat = minH
            
            attributes.frame = CGRect(x: attributesX, y: attributesY, width: attributesW, height: attributesH)
            
            //存放 attributes
            items.append(attributes)
            
            //替换最小的高度
            totlaItemHs[indexObject] = minH + attributesH + minimumLineSpacing
        }
        
        //最大高度
        maxH = totlaItemHs.max()!
        //起始位置
        startIndex = itemCount
    }

    
    //2.返回所有的item
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return items
    }
    
    //3.计算内容尺寸
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
