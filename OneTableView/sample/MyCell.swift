//
//  MyCell.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/12/9.
//

import Foundation
import UIKit

class MyCell: OneTableViewCell<MyData> {
    
    override func didSetModel(model: MyData) {
        self.textLabel?.text = model.text
    }
}

class MyCell1: OneTableViewCell<MyData1> {
    
    override func didSetModel(model: MyData1) {
        self.backgroundColor = .lightGray
        self.textLabel?.text = model.text
    }
}

class MyCoCell: OneCollectionViewCell<MyData> {
    
    var label: UILabel?
    
    override func initView() {
        super.initView()
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.borderWidth = 1
        self.addSubview(label)
        self.label = label
    }
    
    override func didSetModel(model: MyData) {
        self.label?.text = model.text
    }
}

class MyCoCell1: OneCollectionViewCell<MyData1> {
    
    override class var cellSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    var label: UILabel?
    
    override func initView() {
        super.initView()
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1
        self.addSubview(label)
        self.label = label
    }
    
    override func didSetModel(model: MyData1) {
        self.label?.text = model.text
    }
}
