//
//  ViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
/// Disposing
        do {
            //let seq = [1,2,3].makeIterator()
            
            let scheduler = SerialDispatchQueueScheduler(qos: .default)
            let subscription = Observable<Int>.interval(0.3, scheduler: scheduler)
                .subscribe { event in
                    print(event)
            }
            
            Thread.sleep(forTimeInterval: 2.0)
            
            subscription.dispose()
        }
        
        do {
            let scheduler = SerialDispatchQueueScheduler(qos: .default)
            let subscription = Observable<Int>.interval(0.3, scheduler: scheduler)
                .observeOn(MainScheduler.instance)
                .subscribe { event in
                    print(event)
            }
            
            // ....
            subscription.dispose() // called from main thread
        }
        
        do {
            let serialScheduler = SerialDispatchQueueScheduler(qos: .default)
            let subscription = Observable<Int>.interval(0.3, scheduler: serialScheduler)
                .observeOn(serialScheduler)
                .subscribe { event in
                    print(event)
            }
            
            // ...
            subscription.dispose() // executing on same `serialScheduler`
        }
        

    }



}

