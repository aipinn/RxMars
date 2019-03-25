//
//  RMProductViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift


class RMProductViewController: UIViewController {
    var tableView: UITableView?
    let vm = RMProductViewModel()
    fileprivate let disposeBag = DisposeBag()
    
    //Varible
    var model: Variable<RMProduct?> = Variable(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: kScreenBounds, style: .plain)
        guard let tb = tableView else { return }
        tb.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tb)
        
        vm.data.bind(to: tb.rx.items(cellIdentifier: "cell")) {_, product, cell in
            cell.textLabel?.text = product.name
            cell.detailTextLabel?.text = product.price
        }.disposed(by: disposeBag)
        
        tb.rx.modelSelected(RMProduct.self).subscribe { product in
            print(product)
        }.disposed(by: disposeBag)
        
        //Varible
        model.asObservable()
            .subscribe{ model in
            print(model)
        }.disposed(by: disposeBag)
        model.value = RMProduct(name: "meta", price: "1234")
    }
    

}

