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
import CoreLocation

private extension Reactive where Base: UILabel {
    var coordinate: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "lat: \(location.latitude) \nLon: \(location.longitude)"
        }
    }
}

class RMLiteViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var sumL: UILabel!
    
    
    @IBOutlet weak var statusL: UILabel!//地理位置是否可用
    @IBOutlet weak var infoL: UILabel!//地理位置经纬度信息
    @IBOutlet weak var openBtn1: UIButton!//打开偏好设置
    @IBOutlet weak var descL: UILabel!//地理位置打开关闭描述信息
    
    override func viewDidLoad() {
        super.viewDidLoad()

        simpleAddition()
        location()
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

    func location() {
        let noGeolocationView = UIView(frame: view.bounds)
        noGeolocationView.alpha = 0.6;
        noGeolocationView.backgroundColor = .white
        let btn = UIButton(frame: CGRect(x: 10, y: 200, width: 100, height: 30))
        btn.setTitle("Open preference", for: .normal)
        btn.backgroundColor = .orange
        noGeolocationView.addSubview(btn)
        view.addSubview(noGeolocationView)
        
        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized
        .drive(noGeolocationView.rx.isHidden)
        .disposed(by: disposeBag)
        
        geolocationService.location
        .drive(infoL.rx.coordinate)
        .disposed(by: disposeBag)
        
        openBtn1.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
        }
        .disposed(by: disposeBag)
        
        btn.rx.tap
            .bind { [weak self] _ ->Void in
                    self?.openAppPreferences()
        }
        .disposed(by: disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        
        //UIApplication.shared.open(URL(string: UIAlertAction.openSettingsURLString)!, options: [], completionHandler: nil)
    }
}
