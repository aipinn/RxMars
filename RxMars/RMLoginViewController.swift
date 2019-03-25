//
//  RMLoginViewController.swift
//  RxMars
//
//  Created by pinn on 2019/3/24.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minUsernameLength = 6
fileprivate let minPasswordLength = 6

class RMLoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var nameHint: UILabel!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var pwdHint: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UITextField 可以是被观察者 也可以是观察者
        
        //被观察者
        let observable = username.rx.text
        observable.subscribe(onNext: { text in
            if let txt = text {
                print("--"+txt)
            }
        })
        .disposed(by: disposeBag)
        
        //观察者
//        let observer = username.rx.text
//        let text: Observable<String?> = ...
//        text.bind(to: observer)
        
        let usernameValid = username.rx.text.orEmpty
            .map{ $0.count >= minUsernameLength }
            .share(replay: 1)
        
        let passwordValid = password.rx.text.orEmpty
            .map{ $0.count >= minPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable
            .combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: password.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: nameHint.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: pwdHint.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let _ = loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.alertView()
        })
        
    }

    func alertView() {
        let alert = UIAlertController(
            title: "title",
            message: "loging",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "sure", style: .default) { _ in
            print("loging")
        }
        alert.addAction(action)
        navigationController?.present(alert, animated: true, completion: nil)
        
    }


}
