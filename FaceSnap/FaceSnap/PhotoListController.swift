//
//  ViewController.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Camera", for: UIControlState())
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)

        
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager.init(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }
    
    
    // MARK: - Image picker controller
    
    

    // selectors can only recieve objective c functions ...
    @objc fileprivate func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }


}

// MARK: - Media picker manager delegate
extension PhotoListController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(_ manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        // use open GL Es for the context so we use the GPU and not teh CPU for the filtering
        let eaglContext = EAGLContext(api: .openGLES2)
        
        let ciContext = CIContext(eaglContext: eaglContext!)
        
        
        // create instance of photo filter controler with image
        let photoFilterController = PhotoFilterController(image: image, context: ciContext, eaglContext: eaglContext!)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        
        manager.dismissImagePickerController(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
        }
        
    }
    
}



