//
//  style.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/11/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import UIKit

/*
protocol LogoProtocol : class {

    func configureLogo(_ logo: UIImage?, size: CGSize?)
}

extension LogoProtocol where Self:UIViewController {
    func configureLogo(_ logo: UIImage?, size: CGSize?) {
    
        let logoImage = logo ?? UIImage(named: "next_logo")
        let size = size ?? CGSize(width: 40, height: 40)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}


extension UIViewController : LogoProtocol{}

class NEXTViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLogo(nil, size: nil)
    }
}
 */


class NEXTViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLogo(nil, size: nil)
    }
    
    func configureLogo(_ logo: UIImage?, size: CGSize?) {
        
        let logoImage = logo ?? UIImage(named: "next_logo")
        let size = size ?? CGSize(width: 40, height: 40)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        navigationItem.titleView = imageView
    }
    
}


class Style {
    
    //TODO : background icon image
    // timeout for request
    // allow cancle request
    
    static let menuBarBGColor = UIColor.backgroundColor
    static let menuBarTintColor = UIColor.white
    
    
    static let mainButtonColor = UIColor.customeGreen
    static let mainButtonTintColor = UIColor.white
    static let mainButtonBorderColor = UIColor.customeGreen
    
    static let disabledMainButtonColor = UIColor.customeGreen.withAlphaComponent(0.5)
    static let disabledMainButtonTintColor = UIColor.lightGray
    static let disabledMainButtonBorderColor = UIColor.customeGreen.withAlphaComponent(0.5)
    
    static let subButtonColor = UIColor.customeYellow
    static let subButtonTintColor = UIColor.black
    static let subButtonBorderColor = UIColor.customeYellow
    
    static let disabledSubButtonColor = UIColor.customeYellow.withAlphaComponent(0.5)

    static let disabledSubButtonTintColor = UIColor.lightGray
    static let disabledSubButtonBorderColor = UIColor.customeYellow.withAlphaComponent(0.5)

    
    
    
    static let clockFormat = "hh:mm:ss"
    //"yyyy/MM/dd EEEE \nhh:mm:ss a \nzzzz"
    
}



