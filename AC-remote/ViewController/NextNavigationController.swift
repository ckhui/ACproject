//
//  NextNavigationController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/16/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class NextNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initNaviBar()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//    func setLogo() {
//        let logoImage = UIImage(named: "next_logo")
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//        imageView.image = logoImage
//        imageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = imageView
//    }
//    
//    func setNaviBarHeight(height : CGFloat){
//
//       let bounds = self.navigationBar.bounds
//       //self.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
//        navigationBar.sizeThatFits(CGSize(width: bounds.width , height: height))
//    }
//    
//    func initNaviBar(){
//        setNaviBarHeight(height: 200)
//        setLogo()
//    }


}
