//
//  OneTableView.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/8.
//

import Foundation
import UIKit
import MJRefresh

// 获取变量的类型，用object_getClass，不能用type(of:)，
// 后者在某些情况下会失效 (release模式，放进[AnyObject]数组中的变量会被识别成AnyObject，获取不到真正类型)
func className(_ any: Any?) -> String {
    return "\(String(describing: object_getClass(any)))"
}

// D:数据格式
class OneTableView<D: AnyObject> : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var list: [D] = []
    
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        registerCells()
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 子类复写
    // 定义列表中的数据类型和cell类型，数据类型要用className()包起来，以用作Map的key
    // 数据类型与cell类型一对一，或多对一
    open var dataCellDict:[AnyHashable: UITableViewCell.Type] {
        return [:]
    }
    
    // 1.注册类型
    // 根据dataCellDict自动注册，一般不需要复写。除非特殊情况一个数据类型对应多种Cell类型
    open func registerCells() {
        for cellType in dataCellDict.values {
            register(cellType, forCellReuseIdentifier: className(cellType))
        }
    }
    
    // 2.获取数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // 3.获取高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = list[indexPath.row]
        if let cellType = dataCellDict[className(data)] as? BaseOneTableViewCell.Type {
            return cellType.cellHeight
        } else {
            print("heightForRowAt cellType = nil \(data)")
        }
        return 0
    }
    
    // 4.获取cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = list[indexPath.row]
        if let cellType = dataCellDict[className(data)] {
            return dequeueReusableCell(withIdentifier: className(cellType), for: indexPath)
        } else {
            print("cellForRowAt cellType = nil \(data)")
        }
        return UITableViewCell()
    }
    
    // 5.cell即将展示，刷新数据
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        if let cell = cell as? BaseOneTableViewCell {
            cell.setAnyObject(model: list[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // no op
    }

}


// 带下拉刷新和上滑加载更多功能
class OneMJTableView<D: AnyObject>: OneTableView<D> {
    
    var pageIndex = 0
    
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
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
class OneSimpleTableView<D: AnyObject, C: OneTableViewCell<D>>: OneTableView<D> {
    
    override var dataCellDict: [AnyHashable : UITableViewCell.Type] {
        return [className(D.self): C.self]
    }
}


// 只有一种cell的简单列表带刷新 D:数据格式，C:Cell格式
class OneSimpleMJTableView<D: AnyObject, C: OneTableViewCell<D>>: OneMJTableView<D> {
    
    override var dataCellDict: [AnyHashable : UITableViewCell.Type] {
        return [className(D.self): C.self]
    }
}
