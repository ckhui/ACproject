//
//  ImageSegmentedControl.swift
//  CustomeSegmentedControl
//
//  Created by CKH on 23/02/2017.
//  Copyright © 2017 CKH. All rights reserved.
//

import UIKit

class ImageSegmentedControl: UIControl {
    
    private var imageViews = [UIImageView]()
    
    var thumbView = UIView()
    
    var previousIndex : Int = -1
    var selectedIndex : Int = -1 {
        didSet{
            deselectIndex(previousIndex)
            displaySelectedIndex()
            previousIndex = selectedIndex
        }
    }
    
    var tempSavedImageNamed = ""
    var isHided = false
    var imageNames : [String] = ["cold" , "dry", "wet"] {
        didSet{
            setupImages()
        }
    }
    
    var selectedImageNames : [String] = []
    
    override var isEnabled: Bool {
        didSet{
            if isEnabled {
                displaySelectedIndex()
            }else{
                deselectIndex(selectedIndex)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    func setupView() {
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 2
     
        backgroundColor = UIColor.clear
        setupImages()
        
        setupThumbView()
    }
    
    func setupImages() {
        imageViews.forEach {$0.removeFromSuperview()}
        
        imageViews.removeAll(keepingCapacity: true)
        
        for index in 1...imageNames.count {
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.image = UIImage(named: imageNames[index - 1])
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    func setupThumbView() {
        var selectedFrame = self.bounds
        let newWidth = selectedFrame.width / CGFloat(imageNames.count)
        selectedFrame.size.width = newWidth
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.white
        
        let cornerRadius = min(thumbView.frame.width, thumbView.frame.height) / 2
        
        thumbView.layer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
    
        insertSubview(thumbView, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(imageViews.count)
        
        for index in 0...imageViews.count - 1 {
            let label = imageViews[index]
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        for (index,item) in imageViews.enumerated() {
            if item.frame.contains(location){
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func deselectIndex(_ index : Int){
        if index == -1 {
            return
        }
        
        if index == 3 && isHided {
            return
        }
        
        let imageView = imageViews[index]
        imageView.image = UIImage(named: imageNames[index])

    }
    
    
    
    func displaySelectedIndex(){
        if selectedIndex == -1 {
            self.thumbView.frame = CGRect.zero
            return
        }
//        
//        if selectedIndex == 3 && isHided {
//            selectedIndex = 2
//            return
//        }
//        
        
        //if selectedImageNames.count > selectedIndex {
            let imageView = imageViews[selectedIndex]
            let imgName = selectedImageNames[selectedIndex]
            imageView.image = UIImage(named: imgName)
            self.thumbView.frame = imageView.frame
       // }
        
        
    }
    

}

//to hide/show fan auto option when dry / other mode
extension ImageSegmentedControl {
    func hideAuto() {
        
        if !isHided {
            isHided = true
            tempSavedImageNamed = imageNames.removeLast()
        }
    }
    
    func showAuto() {
        if isHided && tempSavedImageNamed != "" {
            isHided = false
            imageNames.append(tempSavedImageNamed)
            
        }
        
    }
}


