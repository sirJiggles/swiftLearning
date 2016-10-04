//
//  PhotoFilterController.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    fileprivate var mainImage: UIImage {
        didSet {
            photoImageView.image = mainImage
        }
    }
    fileprivate let context: CIContext
    fileprivate let eaglContext: EAGLContext
    
    fileprivate let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        // spacing of each item
        flowLayout.minimumLineSpacing = 10
        
        // how many can fit on one line, set to high number so does not wrap to 
        // more than one line
        flowLayout.minimumInteritemSpacing = 1000
        
        // each item should have withd and height
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FilterImageCell.self, forCellWithReuseIdentifier: FilterImageCell.reuseIdentifier)
        
        return collectionView
    }()
    
    fileprivate lazy var filteredImages: [CIImage] = {
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
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.dismissPhotFilterController))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        
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
        
        NSLayoutConstraint.activate([
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 200.0),
            filtersCollectionView.topAnchor.constraint(equalTo: filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
}


//Mark: - UICollectionViewDataSource
extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterImageCell.reuseIdentifier, for: indexPath) as! FilterImageCell
        
        let ciImage = filteredImages[(indexPath as NSIndexPath).row]
        
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        
        return cell
    }
    
}

//Mark: - UICollectionViewDelegate
extension PhotoFilterController: UICollectionViewDelegate {
    
    // click a filtered image
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = filteredImages[(indexPath as NSIndexPath).row]
        
        // use context to draw cgimage in bounds of main imag
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        mainImage = UIImage(cgImage: cgImage!)
    }
}

//Mark: - Navigation
extension PhotoFilterController {
    @objc fileprivate func dismissPhotFilterController () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func presentMetadataController() {
        let photoMetaDataController = PhotoMetadataController(photo: self.mainImage)
        self.navigationController?.pushViewController(photoMetaDataController, animated: true)
    }
}



