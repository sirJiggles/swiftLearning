//
//  PhotoMetadataController.swift
//  FaceSnap
//
//  Created by Gareth on 12/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController {
    
    fileprivate let photo: UIImage
    
    init(photo: UIImage) {
        self.photo = photo
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    //MARK: - meta data fields
    fileprivate lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var imageViewHeight: CGFloat = {
        // get width to height ratio first 
        let imageFactor = self.photoImageView.frame.size.height / self.photoImageView.frame.size.width
        
        // width table view is in
        let screenWidth = UIScreen.main.bounds.size.width
        
        // returns height needed to be 100% width
        return screenWidth * imageFactor
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // implicetly unwrapped property
    // might not need instance if user does not click add location
    fileprivate var locationManager: LocationManager!
    
    fileprivate var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}


extension PhotoMetadataController {
    // Mark - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // only going to be three sections with single row
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case (0,0):
            cell.contentView.addSubview(photoImageView)
            
            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
                ])
        case(1,0):
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
        default: break
        }
        
        
        return cell
    }
}

// MARK - UITableViewDelegate
extension PhotoMetadataController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case(0,0): return imageViewHeight
        default: return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        // clicking on the location label
        case (1,0):
            // hide location label
            locationLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            // now get instance
            locationManager = LocationManager()
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.locationLabel.isHidden = false
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else {
                        return
                    }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
        default:
            break
        }
    }
}






