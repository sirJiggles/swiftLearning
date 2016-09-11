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
        let button = UIButton(type: .System)
        
        button.setTitle("Camera", forState: .Normal)
        button.tintColor = .whiteColor()
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), forControlEvents: .TouchUpInside)

        
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
        
        NSLayoutConstraint.activateConstraints([
            cameraButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            cameraButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            cameraButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            cameraButton.heightAnchor.constraintEqualToConstant(56.0)
            ])
    }
    
    
    // MARK: - Image picker controller
    
    

    // selectors can only recieve objective c functions ...
    @objc private func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true)
    }


}

// MARK: - Media picker manager delegate
extension PhotoListController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        // use open GL Es for the context so we use the GPU and not teh CPU for the filtering
        let eaglContext = EAGLContext(API: .OpenGLES2)
        
        let ciContext = CIContext(EAGLContext: eaglContext)
        
        
        // create instance of photo filter controler with image
        let photoFilterController = PhotoFilterController(image: image, context: ciContext, eaglContext: eaglContext)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        
        manager.dismissImagePickerController(animated: true) {
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
        
    }
    
}




