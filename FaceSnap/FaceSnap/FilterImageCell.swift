//
//  FilterImageCell.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import GLKit

class FilterImageCell: UICollectionViewCell {
    
    // the string initializer here sets the name of the string to be the name of the class
    // fancy
    static let reuseIdentifier = String(describing: FilterImageCell.self)
    
    var eaglContext: EAGLContext!
    var ciContext: CIContext!
    
    // need context to create view so it is lazy
    // as only create when we use
    lazy var glkView: GLKView = {
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    var image: CIImage!
    
    // in uiview sub class we use layout subviews as apposed to will layout subviews
    // as this is not a UIView
    override func layoutSubviews() {
        // cant call add sub view need to make them as sub views of classes content view
        contentView.addSubview(glkView)
        glkView.translatesAutoresizingMaskIntoConstraints = false;
        
        // fill the container of the content view
        NSLayoutConstraint.activate([
            glkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glkView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            glkView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            glkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}


extension FilterImageCell: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // get size of space we want to draw in
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        let drawableRect = CGRect(origin: CGPoint.zero, size: drawableRectSize)
        
        // ask context to draw image
        ciContext.draw(image, in: drawableRect, from: image.extent)
    }
}





