//
//  ViewController.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreData

class PhotoListController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let paddingDistance: CGFloat = 16.0
        let itemSize = (screenWidth - paddingDistance)/2.0
        
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()
    
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
    
    lazy var dataSource: PhotoDataSource = {
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView: self.collectionView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        collectionView.dataSource = dataSource
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        
        // NOTE: The order here matters as the items are an array, as the cam button needs to be
        // on top of the collection view, it needs to be added to the view after the collection view
        
        // collection view
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // cam button
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
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

// Mark: - Navigation
extension PhotoListController {
    fileprivate func setupNavigationBar() {
        let sortTagsButton = UIBarButtonItem(title: "Tags", style: .plain, target: self, action: #selector(PhotoListController.presentSortController))
        // TODO add the sort by location button
        navigationItem.setRightBarButtonItems([sortTagsButton], animated: true)
    }
    
    @objc private func presentSortController() {
        // get the tags using the request
        let tagDataSource = SortableDataSource<Tag>(fetchRequest: Tag.allTagsRequest, managedObjectContext: CoreDataController.sharedInstance.managedObjectContext)
        
        let sortItemSelect = SortItemSelector(sortItems: tagDataSource.results)
        
        let sortController = PhotoSortListController(dataSource: tagDataSource, sortItemSelector: sortItemSelect)
        
        sortController.onSortSelection = { checkedItems in
            
            if !checkedItems.isEmpty {
                var predicates = [NSPredicate]()
                
                for tag in checkedItems {
                    let predicate = NSPredicate(format: "%K CONTAINS %@", "tags.title", tag.title)
                    predicates.append(predicate)
                }
                
                // compound predcates are collection of sub predicates and how to treat them if some
                // rules are matched for example first
                // eg should summer and vacation only be matched or summer only or vacation only and so on for tags
                let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
                
                self.dataSource.performFetch(withPredicate: compoundPredicate)
            } else {
                self.dataSource.performFetch(withPredicate: nil)
            }
            
        }
        
        let navigationController = UINavigationController(rootViewController: sortController)
        
        present(navigationController, animated: true, completion: nil)
    }
}




