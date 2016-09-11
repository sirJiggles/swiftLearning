//
//  PhotoFilterController.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    private var mainImage: UIImage {
        didSet {
            photoImageView.image = mainImage
        }
    }
    private let context: CIContext
    private let eaglContext: EAGLContext
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .Center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        // spacing of each item
        flowLayout.minimumLineSpacing = 10
        
        // how many can fit on one line, set to high number so does not wrap to 
        // more than one line
        flowLayout.minimumInteritemSpacing = 1000
        
        // each item should have withd and height
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .whiteColor()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(FilterImageCell.self, forCellWithReuseIdentifier: FilterImageCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private lazy var filteredImages: [CIImage] = {
        // create instance of filtered image builder class and pass in image we want to work with
        let filteredImageBuilder = FilteredImageBuilder(image: self.mainImage, context: self.context)
        
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        self.mainImage = image
        self.context = context
        self.eaglContext = eaglContext
        self.photoImageView.image = self.mainImage
        super.init(nibName: nil, bundle: nil)
    }
    
    // not using story board so crash if tried
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(PhotoFilterController.dismissPhotFilterController))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // Layout Code
    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activateConstraints([
            filtersCollectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filtersCollectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            filtersCollectionView.heightAnchor.constraintEqualToConstant(200.0),
            filtersCollectionView.topAnchor.constraintEqualToAnchor(filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            photoImageView.bottomAnchor.constraintEqualToAnchor(filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            photoImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            photoImageView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            ])
    }
}


//Mark: - UICollectionViewDataSource
extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FilterImageCell.reuseIdentifier, forIndexPath: indexPath) as! FilterImageCell
        
        let ciImage = filteredImages[indexPath.row]
        
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        
        return cell
    }
    
}

//Mark: - UICollectionViewDelegate
extension PhotoFilterController: UICollectionViewDelegate {
    
    // click a filtered image
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ciImage = filteredImages[indexPath.row]
        
        // use context to draw cgimage in bounds of main imag
        let cgImage = context.createCGImage(ciImage, fromRect: ciImage.extent)
        mainImage = UIImage(CGImage: cgImage)
    }
}

//Mark - Navigation
extension PhotoFilterController {
    @objc private func dismissPhotFilterController () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func presentMetadataController() {
        
    }
}



