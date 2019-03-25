//
//  RMImagePickerViewController.swift
//  RxMars
//
//  Created by emoji on 2019/3/25.
//  Copyright © 2019 emoji. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RMImagePickerViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        cameraButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                    }
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                    .take(1)
            }
            .map { info in
                return info["UIImagePickerControllerOriginalImage"] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
      
    }

    

}
