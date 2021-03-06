//
//  OneTableViewCell.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/8.
//

import Foundation
import UIKit

class BaseOneTableViewCell: UITableViewCell {
    
    class var cellHeight: CGFloat {
        return 66
    }
    
    func setAnyObject(model: AnyObject?) {
        // no op
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initView() {
        // no op
    }
}

class OneTableViewCell<D>: BaseOneTableViewCell {
    
    var model: D? {
        didSet {
            if let model = model {
                didSetModel(model: model)
            }
        }
    }
    
    override func setAnyObject(model: AnyObject?) {
        self.model = model as? D
    }
    
    open func didSetModel(model: D) {
        // no op
    }
}
