//
//  OneCollectionViewCell.swift
//  OneCollectionViewCell
//
//  Created by 陈荣超 on 2021/11/8.
//

import Foundation
import UIKit

class BaseOneCollectionViewCell: UICollectionViewCell {
    
    class var cellSize: CGSize {
        return CGSize(width: 300, height: 66)
    }
    
    func setAnyObject(model: AnyObject?) {
        // no op
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initView() {
        // no op
    }
}

class OneCollectionViewCell<D>: BaseOneCollectionViewCell {
    
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
