//
//  imageMerger.swift
//  black-bars
//
//  Created by Toby Courtis on 29/09/2020.
//  Copyright © 2020 Toby Courtis. All rights reserved.
//

import UIKit

extension UIImage {

    // TODO alter the image merge method to my square requirements
    static func imageByMergingImages(topImage: UIImage, bottomImage: UIImage, scaleForTop: CGFloat = 1.0) -> UIImage {
        let size = bottomImage.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        bottomImage.draw(in: container)

        let topWidth = size.width / scaleForTop
        let topHeight = size.height / scaleForTop
        let topX = (size.width / 2.0) - (topWidth / 2.0)
        let topY = (size.height / 2.0) - (topHeight / 2.0)

        topImage.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

}
