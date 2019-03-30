//
//  SimpleTableViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/30.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewController: UIViewController {

    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
        .modelSelected(String.self)
            .subscribe(onNext: { (value) in
                print(value)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print(indexPath.row)
            })
            .disposed(by: disposeBag)

    }



}
