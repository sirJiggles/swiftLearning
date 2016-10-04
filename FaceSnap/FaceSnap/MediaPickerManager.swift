//
//  MediaPickerManager.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol MediaPickerManagerDelegate: class {
    func mediaPickerManager(_ manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    fileprivate let imagePickerController = UIImagePickerController()
    
    fileprivate let presentingViewController: UIViewController
    
    // weak so we dont get a ref cycle
    weak var delegate: MediaPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        
        // simulator has no cam
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            
            // use front cam
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        // only allow images, media picker manager has some special types for this
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    func presentImagePickerController(animated: Bool) {
        presentingViewController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (Void) -> Void) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
}

extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // call our delegate 
        delegate?.mediaPickerManager(self, didFinishPickingImage: image)
    }
}



















