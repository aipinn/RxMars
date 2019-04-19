import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport

// 观察者Observer
//AnyObserver
let disposedBag = DisposeBag()
let url = URL(string: "https://httpbin.org/get")
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

//AsyncSubject只会监听最后一个元素
do {
    let subject = AsyncSubject<String>()

    subject.subscribe {
        //print("Subscription: 1 Event:", $0)
    }

    subject.onNext("🐈")
    subject.onNext("🐩")
    subject.onNext("🐘")
    subject.onCompleted()
}
//PublishSubject 只对订阅后产生的元素进行监听,之前的不理会
do {
    let subject = PublishSubject<String>()
    subject.subscribe{
        //print("Subscription: 1 Event:", $0)
    }
    subject.onNext("🐈")
    subject.onNext("🐩")
    
    subject.subscribe{
        //print("Subscription: 2 Event:", $0)
    }
    subject.onNext("🌹")
    subject.onNext("😆")
}

//ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
do {
    let subject = ReplaySubject<String>.create(bufferSize: 1)

    subject.subscribe{
        //print("Subscription: 1 Event:", $0)
    }
    subject.onNext("🐈")
    subject.onNext("🐩")
    subject.subscribe{
        //print("Subscription: 2 Event:", $0)
    }
    subject.onNext("🌹")
    subject.onNext("😆")
}

do {
    let subject = BehaviorSubject(value: "😜")
    subject.subscribe{
        print("Subscription: 1 Event:", $0)
    }
    subject.onNext("🐈")
    subject.onNext("🐩")
    subject.subscribe{
        print("Subscription: 2 Event:", $0)
    }
    
    subject.onNext("🌹")
    subject.onNext("😆")
    subject.subscribe{
        print("Subscription: 3 Event:", $0)
    }
    subject.onNext("🍎")
    subject.onNext("🍌")
}

let rxJson: Observable<String> = Observable.create { o -> Disposable in
    return Disposables.create()
}
let retryDelay: Double = 5  // 重试延时 5 秒

rxJson
    .retry(3)
    .subscribe(onNext: { string in
        
    })
    .disposed(by: disposedBag)

rxJson
    .retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
        return Observable.timer(5, scheduler: MainScheduler.instance)
    }.subscribe { (str) in
        
    }
    .disposed(by: disposedBag)

//flatMap被弃用
[1,2,3].compactMap { i in
    print(i)
}

Observable.of(1,2,3,4)
Observable.from([1,2,3,4]).map { Int($0) }
    .filter {
        
        return true
}

