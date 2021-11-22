//
//  ViewController.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/8.
//

import UIKit

class ViewController: UIViewController {

    lazy var label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var tableView = MyMultiTableView()
                                     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "OneTableView Demo"
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

}

// MARK: 只有一种类型的简单列表
class MyTableView: OneSimpleTableView<MyData, MyCell> {
    
    override func doRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var res:[MyData] = []
            for i in 0...30 {
                let d = MyData()
                d.text = "row \(i)"
                res.append(d)
            }
            self.handleSuccess(list: res, isNoMore: self.pageIndex > 2)
        }
    }
    
}

class MyData {
    var text: String?
}

class MyCell: OneTableViewCell<MyData> {
    
    override func didSetModel(model: MyData) {
        self.textLabel?.text = model.text
    }
}

class MyData1 {
    var text: String?
}

class MyCell1: OneTableViewCell<MyData1> {
    
    override func didSetModel(model: MyData1) {
        self.backgroundColor = .lightGray
        self.textLabel?.text = model.text
    }
}

// MARK: 多种类型的列表
class MyMultiTableView: OneTableView<AnyObject> {
    
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
                let d = MyData()
                d.text = "type0 \(i)"
                res.append(d)
                
                let d1 = MyData1()
                d1.text = "type1 \(i)"
                res.append(d1)
            }
            self.handleSuccess(list: res, isNoMore: self.pageIndex > 2)
        }
    }
}
