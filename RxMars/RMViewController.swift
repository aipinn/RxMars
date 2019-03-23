//
//  RMViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift

class RMViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        
        let _ = myJust(0).subscribe(onNext: { n in
            print(n)
        })
        
    }

    @IBAction func productAction(_ sender: Any) {
        let vc = RMProductViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @discardableResult
    func myJust<E>(_ element: E) -> Observable<E> {
        return Observable.create({ observer -> Disposable in
            //observer.onNext(element)//Convenience method equivalent to on(.next(element: E))
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        })
    }
}

extension RMViewController {
    

}
