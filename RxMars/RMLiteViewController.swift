//
//  RMLiteViewController.swift
//  RxMars
//
//  Created by pinn on 2019/3/26.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RMLiteViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var sumL: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        simpleAddition()
    }
    //一个简单的加法
    func simpleAddition() {

        Observable.combineLatest(tf1.rx.text.orEmpty,
                                 tf2.rx.text.orEmpty,
                                 tf3.rx.text.orEmpty) { v1, v2, v3 -> Int in
            return (Int(v1) ?? 0)+(Int(v2) ?? 0)+(Int(v3) ?? 0)
        }
            .map { $0.description }
            .bind(to: sumL.rx.text)
            .disposed(by: disposeBag)
    }

}
