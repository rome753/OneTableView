//
//  OneUtils.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/20.
//

import Foundation
import UIKit

// 获取变量的类型，用object_getClass，不能用type(of:)，
// 后者在某些情况下会失效 (release模式，放进[AnyObject]数组中的变量会被识别成AnyObject，获取不到真正类型)
func className(_ any: Any?) -> String {
    return "\(String(describing: object_getClass(any)))"
}

extension UIView {
    
    func getVC() -> UIViewController? {
        var resp = self.next
        while resp != nil {
            if let resp = resp as? UIViewController {
                return resp
            }
            resp = resp?.next
        }
        return nil
    }
}
