//
//  FilteredImageBuilder.swift
//  FaceSnap
//
//  Created by Gareth on 11/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import Foundation
import CoreImage


final class FilteredImageBuilder {
    
    fileprivate struct PhotoFilter {
        static let colorClamp = "CIColorClamp"
        static let colorControls = "CIColorControls"
        static let photoEffectInstant = "CIPhotoEffectInstant"
        static let photoEffectProcess = "CIPhotoEffectProcess"
        static let photoEffectNoir = "CIPhotoEffectNoir"
        static let sepia = "CISepiaTone"
        
        static func defaultFilters() -> [CIFilter] {
            // color clamping
            let colorClamp = CIFilter(name: PhotoFilter.colorClamp)!
            colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // color controls
            let colorControls = CIFilter(name: PhotoFilter.colorControls)!
            
            // 10% saturation
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // photo effect filters
            let photoEffectInstant = CIFilter(name: PhotoFilter.photoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.photoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.photoEffectNoir)!
            
            // sepia
            let sepia = CIFilter(name: PhotoFilter.sepia)!
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectNoir, photoEffectProcess, photoEffectInstant, sepia]
        }
    }
    
    fileprivate let image: UIImage
    fileprivate let context: CIContext
    
    
    init(image: UIImage, context: CIContext) {
        self.image = image
        self.context = context
    }
    
    func imageWithDefaultFilters() -> [CIImage]{
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(self.image, withFilter: $0) }
    }
    
    func image(_ image: UIImage, withFilter filter:CIFilter) -> CIImage {
        // ci image is as we are processing it
        
        // using coalecing we unwrap and the first value and use if it not nil
        // if it is nil however we use the second value, in this case the image, force unwrapped and converted
        let inputImage = image.ciImage ?? CIImage(image: image)!
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let outputImage = filter.outputImage!
        
        return outputImage.cropping(to: inputImage.extent)
        
        // extent is the size of the image (as filter could have chnaged the size of the image)
//        return context.createCGImage(filter.outputImage!, fromRect: inputImage.extent)
    }
    
}





