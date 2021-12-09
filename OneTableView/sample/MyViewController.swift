//
//  ListVC.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/12/9.
//

import Foundation
import UIKit

class MyViewController: UIViewController {
    
    lazy var listView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.frame = view.bounds
    }
}

// MARK: 只有一种类型的简单列表
class MyTableView: OneSimpleTableView<MyData, MyCell> {
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        
        var res:[MyData] = []
        for i in 0...10 {
            let d = MyData("row \(i)")
            res.append(d)
        }
        self.list = res
        self.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 只有一种类型的简单列表带刷新
class MyRefreshTableView: OneSimpleMJTableView<MyData, MyCell> {
    
    override func doRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var res:[MyData] = []
            for i in 0...30 {
                let d = MyData("row \(i)")
                res.append(d)
            }
            self.handleSuccess(list: res, isNoMore: self.pageIndex > 2)
        }
    }
    
}

// MARK: 多种类型的列表带刷新
class MyMultiTableView: OneMJTableView<AnyObject> {
    
    override var dataCellDict: [AnyHashable : UITableViewCell.Type] {
        return [
            className(MyData.self): MyCell.self,
            className(MyData1.self): MyCell1.self,
        ]
    }
    
    override func doRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var res:[AnyObject] = []
            for i in 0...5 {
                let d = MyData("type0 \(i)")
                res.append(d)
                
                let d1 = MyData1("type1 \(i)")
                res.append(d1)
            }
            self.handleSuccess(list: res, isNoMore: self.pageIndex > 2)
        }
    }
}

// MARK: 只有一种类型的简单列表
class MyCollectionView: OneSimpleCollectionView<MyData, MyCoCell> {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        var res:[MyData] = []
        for i in 0...30 {
            let d = MyData("item \(i)")
            res.append(d)
        }
        self.list = res
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 多种类型的列表带刷新
class MyMultiCollectionView: OneMJCollectionView<AnyObject> {
    
    override var dataCellDict: [AnyHashable : UICollectionViewCell.Type] {
        return [
            className(MyData.self): MyCoCell.self,
            className(MyData1.self): MyCoCell1.self,
        ]
    }
    
    override func doRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var res:[AnyObject] = []
            for i in 0...5 {
                let d = MyData("type0 \(i)")
                res.append(d)
                
                let d1 = MyData1("type1 \(i)")
                res.append(d1)
            }
            self.handleSuccess(list: res, isNoMore: self.pageIndex > 2)
        }
    }
}
