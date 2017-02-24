//
//  SliderViewExtension.swift
//  
//
//  Created by CKH on 23/02/2017.
//
//

import Foundation
import UIKit

extension UISlider {
    var thumbCenterX: CGFloat {
        let _trackRect = trackRect(forBounds: self.bounds)
        let _thumbRect = thumbRect(forBounds: self.bounds, trackRect: _trackRect, value: value)
        return _thumbRect.origin.x + _thumbRect.width / 2
    }
}
