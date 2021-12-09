//
//  ViewController.swift
//  OneTableView
//
//  Created by 陈荣超 on 2021/11/8.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView = MenuTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "OneTableView Demo"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

}

class MenuTableView: OneSimpleTableView<MyData, MyCell> {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        list.append(MyData("简单tableView"))
        list.append(MyData("简单tableView带刷新"))
        list.append(MyData("多类型tableView带刷新"))
        list.append(MyData("简单collectionView"))
        list.append(MyData("多类型collectionView带刷新"))
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var view = UIView()
        switch indexPath.row {
        case 0:
            view = MyTableView()
        case 1:
            view = MyRefreshTableView()
        case 2:
            view = MyMultiTableView()
        case 3:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 100, height: 80)
            view = MyCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        case 4:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
            view = MyMultiCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        default:
            view = MyTableView()
        }
        let vc = MyViewController()
        vc.title = list[indexPath.row].text
        vc.listView = view
        getVC()?.navigationController?.pushViewController(vc, animated: true)
    }
}
