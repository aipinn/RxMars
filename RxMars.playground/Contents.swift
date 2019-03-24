import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport

// 观察者Observer
//AnyObserver
let disposedBag = DisposeBag()
let url = URL(string: "")
let request = URLRequest(url: url!)
URLSession.shared.rx.data(request: request)
    .subscribe(onNext: { data in
        
    }, onError: { error in
        
    })
    .disposed(by: disposedBag)


//等价于:
let observer: AnyObserver<Data> = AnyObserver { event in
    switch event {
    case .next(let data):
        print(data)
    case .error(let error):
        print(error)
    default: break
        
    }
}

URLSession.shared.rx.data(request: request)
.subscribe(observer)
.disposed(by: disposedBag)


/*
 usernameValid
 .bind(to: nameHint.rx.isHidden)
 .disposed(by: disposeBag)
 */

//等价于:
let username = UITextField()
let nameHint = UILabel()
let usernameValid = username.rx.text.orEmpty
    .map{ $0.count >= 6 }
    .share(replay: 1)

let oberver: AnyObserver<Bool> = AnyObserver { event in
    switch event {
    case .next(let isHidden):
        nameHint.isHidden = isHidden
    default:
        break
    }
}
usernameValid
    .bind(to: oberver)
    .disposed(by: disposedBag)

// Binder

//let binder: Binder<Bool> = Binder(usernameValid) { view, isHidden in
//    view.isHidden = isHidden
//}

// .rx.isHidden的由来, isHidden是UIView的共有属性,可以创建扩展来共用代码
// 这样不必为每一个UI控件单独创建该观察者,许多UI观察者都是这样创建的.
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, isHidden in
            view.isHidden = isHidden
        }
    }
}

extension Reactive where Base: UIControl {
    public var isEnable: Binder<Bool> {
        return Binder(self.base) {control, isEnable in
            control.isEnabled = isEnable
        }
    }
}

extension Reactive where Base: UILabel {
    public var text: Binder<String> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
}

