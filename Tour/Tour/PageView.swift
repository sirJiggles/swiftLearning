//
//  PageViewConytoller.swift
//  Tour
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import UIKit

class PageView: UIView {
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageImage: UIImageView!
    
    class func loadFromNib() -> PageView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: "PageView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! PageView
        
        return view
        
    }
    
    func configure(data: [String:String]) {
        pageLabel.text = data["title"]
        let image = UIImage(named: data["image"]!)
        pageImage.image = image;
    }
}