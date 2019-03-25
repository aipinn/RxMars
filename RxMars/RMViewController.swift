//
//  RMViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/23.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift

enum DataError: Error {
    case cantParseJSON
}

class RMViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = myJust(0).subscribe(onNext: { n in
            print(n)
        })

        let seq = myFrom([1,2,3])
        let _ = seq.subscribe(onNext: { e in
            print(e)
        })
        print("-----middle")
        let _ = seq.subscribe(onNext: {e in
            print(e)
        })
        
        let counter = myInterval(0.1)
        print("interval started")
        let subscription = counter.subscribe(onNext: { n in
            print("interval \(n)")
        })
        Thread.sleep(forTimeInterval: 0.501)
        print("T##items: Any...##Any")
        subscription.dispose()
        print("interval ended")
        
        do {
            let counter = myInterval(1)
            let sub1 = counter.subscribe(onNext: { n in
                print("sub1 \(n)")
            })

            let sub2 = counter.subscribe(onNext: { n in
                print("sub2 \(n)")
            })

            Thread.sleep(forTimeInterval: 5)
            sub1.dispose()
            Thread.sleep(forTimeInterval: 5)
            sub2.dispose()

        }
        
        do {
            let counter = myInterval(0.1).share(replay: 1)
            print("started")
            let sub1 = counter.subscribe(onNext: { n in
                print("sub1 \(n)")
            })

            let sub2 = counter.subscribe(onNext: { n in
                print("sub2 \(n)")
            })

            Thread.sleep(forTimeInterval: 0.5)
            sub1.dispose()
            Thread.sleep(forTimeInterval: 0.5)
            sub2.dispose()
            print("ended")
        }
        
        getRepo(kHttpOrgGet)
            .subscribe(onSuccess: { json in
                print("JSON: ", json)
            }, onError: { error in
                print("Error: ", error)
            }).disposed(by: DisposeBag())
        
        
    }

    @IBAction func loginAction(_ sender: Any) {
        navigationController?.pushViewController(RMLoginViewController(), animated: true)
        
    }
    @IBAction func productAction(_ sender: Any) {
         navigationController?.pushViewController(RMProductViewController(), animated: true)
        
    }
    @IBAction func imagePickerAction(_ sender: Any) {
        navigationController?.pushViewController(RMImagePickerViewController(), animated: true)
    }
    
}

//MARK: 创建自己的被观察者Observable
extension RMViewController {
    
    @discardableResult
    func myJust<E>(_ element: E) -> Observable<E> {
        return Observable.create({ observer -> Disposable in
            //observer.onNext(element)//Convenience method equivalent to on(.next(element: E))
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        })
    }
    //When generating synchronous sequences, the usual disposable to return is singleton instance of NopDisposable.
    func myFrom<E>(_ sequenec: [E]) -> Observable<E> {
        return Observable.create({ observer -> Disposable in
            for element in sequenec {
                observer.onNext(element)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func myInterval(_ interval: TimeInterval) -> Observable<Int> {
        return Observable.create({ observer -> Disposable in
            print("in Subscribed")
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create {
                print("in Disposed")
                timer.cancel()
            }
            
            var next = 0
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                observer.onNext(next)
                next = next+1
            }
            timer.resume()
            return cancel
        })
    }
    
    func createURLObservable() {
        // 创建Observable
        typealias JSON = Any
        let json: Observable<JSON> = Observable.create { (observer) -> Disposable in
            let url = URL(string: "http://httpbin.org/get")
            let task = URLSession.shared.dataTask(with: url!,
                                                  completionHandler: { (data, response, error) in
                                                    
                                                    guard error == nil else {
                                                        observer.onError(error!)
                                                        return
                                                    }
                                                    guard let data = data,
                                                        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                                                        else {
                                                            observer.onError(DataError.cantParseJSON)
                                                            return
                                                    }
                                                    observer.onNext(jsonObject)
                                                    observer.onCompleted()
                                                    
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        let _ = json.subscribe(onNext: { (json) in
            print(json)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }
    }
    
    func createMySequence() {
        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        }
        
        let _ = numbers.subscribe { n in
            print(n)
        }
    }

    func getRepo (_ repo: String) -> Single<[String: Any]> {
        return Single.create(subscribe: { (single) -> Disposable in
            let url = URL(string: repo)
            let task = URLSession.shared.dataTask(with: url!,
                                                  completionHandler: { (data, response, error) in
                                                    
                                                    if let error = error {
                                                        single(.error(error))
                                                        return
                                                    }
                                                    guard let data = data,
                                                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                                                        let result = json as? [String: Any]
                                                        else {
                                                            single(.error(DataError.cantParseJSON))
                                                            return
                                                    }
                                                    single(.success(result))
                                                    
            })
            task.resume()
            return Disposables.create { task.cancel()}
        })
        
    }
}

//MARK: 创建自己的观察者Observer
extension RMViewController {
    
    
}

