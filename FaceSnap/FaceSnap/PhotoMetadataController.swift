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
    
    fileprivate lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Summer vacation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        
        navigationItem.rightBarButtonItem = saveButton
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
        case(2,0):
            
            cell.contentView.addSubview(tagsTextField)
            
            NSLayoutConstraint.activate([
                tagsTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                tagsTextField.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                tagsTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                tagsTextField.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0)
                ])
            
        default: break
        }
        
        
        return cell
    }
}

// MARK: - Helper methods
extension PhotoMetadataController {
    // todo use text delegate methods to validate that the text is not empty and so on
    
    func tagsFromTextField() -> [String] {
        guard let tags = tagsTextField.text else {
            return []
        }
        // split the text 
        let commaSeperatedTextSubSeq = tags.characters.split(separator: ",")
        // convert to strings
        let commaSeperatedStrings = commaSeperatedTextSubSeq.map(String.init)
        // convert to lowercase
        let lowercaseTags = commaSeperatedStrings.map({ $0.lowercased() })
        
        // return the array that contains no white space and new lines
        return lowercaseTags.map({
            $0.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        })
    }
}

// MARK: - Persistance

extension PhotoMetadataController {
    @objc fileprivate func savePhotoWithMetadata() {
        let tags = tagsFromTextField()
        // create the model record
        Photo.photoWith(image: photo, tags: tags, location: location)
        
        // save it
        CoreDataController.save()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
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
    
    // Sets the header for each section in the table view
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Photo"
        case 1:
            return "Enter a location"
        case 2:
            return "Enter tags"
        default:
            return nil
        }
    }
}






