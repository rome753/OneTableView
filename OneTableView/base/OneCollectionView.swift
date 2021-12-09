//
//  OneCollectionView.swift
//  OneCollectionView
//
//  Created by 陈荣超 on 2021/11/24.
//

import Foundation
import UIKit
import MJRefresh

// D:数据格式
class OneCollectionView<D: AnyObject> : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var list: [D] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCells()
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.bounces = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 子类复写
    // 定义列表中的数据类型和cell类型，数据类型要用className()包起来，以用作Map的key
    // 数据类型与cell类型一对一，或多对一
    open var dataCellDict:[AnyHashable: UICollectionViewCell.Type] {
        return [:]
    }
    
    // 1.注册类型
    // 根据dataCellDict自动注册，一般不需要复写。除非特殊情况一个数据类型对应多种Cell类型
    open func registerCells() {
        for cellType in dataCellDict.values {
            register(cellType, forCellWithReuseIdentifier: className(cellType))
        }
    }
    
    // 2.获取数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    // 3.获取cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = list[indexPath.row]
        if let cellType = dataCellDict[className(data)] {
            return dequeueReusableCell(withReuseIdentifier: className(cellType), for: indexPath)
        } else {
            print("cellForItemAt cellType = nil \(data)")
        }
        return UICollectionViewCell()
    }
    
    // 4.cell即将展示，刷新数据
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? BaseOneCollectionViewCell {
            cell.setAnyObject(model: list[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no op
    }
    
}


// 带下拉刷新和上滑加载更多功能
class OneMJCollectionView<D: AnyObject>: OneCollectionView<D> {
    
    var pageIndex = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        if hasRefresh() {
            self.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        }
        if hasLoadMore() {
            self.mj_footer = MJRefreshAutoStateFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
            self.mj_footer?.isHidden = true
        }
        DispatchQueue.main.async {
            if self.willRequestOnInit() {
                self.mj_header?.beginRefreshing()
                self.loadNewData()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loadNewData() {
        pageIndex = 0
        doRequest()
    }
    
    @objc func loadMoreData() {
        doRequest()
    }
    
    open func hasRefresh() -> Bool {
        return true
    }
    
    open func hasLoadMore() -> Bool {
        return true
    }
    
    open func willRequestOnInit() -> Bool {
        return true
    }
    
    open func doRequest() {
        // no op
    }
    
    open func handleSuccess(list: [D]?, isNoMore: Bool) {
        guard let list = list else {
            handleFail()
            return
        }
        if pageIndex == 0 {
            self.list = list
            self.reloadData()
            pageIndex += 1
        } else {
            self.list.append(contentsOf: list)
            self.reloadData()
            pageIndex += 1
        }
        self.mj_header?.endRefreshing()
        
        self.mj_footer?.isHidden = self.list.isEmpty
        if isNoMore {
            self.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            self.mj_footer?.endRefreshing()
        }
    }

    open func handleFail() {
        self.mj_header?.endRefreshing()
        self.mj_footer?.endRefreshingWithNoMoreData()
        self.mj_footer?.isHidden = self.list.isEmpty
    }
}


// 只有一种cell的简单列表 D:数据格式，C:Cell格式
class OneSimpleCollectionView<D: AnyObject, C: OneCollectionViewCell<D>>: OneCollectionView<D> {
    
    override var dataCellDict: [AnyHashable : UICollectionViewCell.Type] {
        return [className(D.self): C.self]
    }
}

// 只有一种cell的简单列表带刷新 D:数据格式，C:Cell格式
class OneSimpleMJCollectionView<D: AnyObject, C: OneCollectionViewCell<D>>: OneMJCollectionView<D> {
    
    override var dataCellDict: [AnyHashable : UICollectionViewCell.Type] {
        return [className(D.self): C.self]
    }
}
