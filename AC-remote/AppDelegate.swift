//
//  AppDelegate.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/4/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor =  Style.menuBarBGColor
        navBarAppearance.tintColor = Style.menuBarTintColor
//        if let image = UIImage(named: "next_logo"),
//            let image2 = UIImage().resizeImage(image: image, newHeight: 40.0) {
//            image2.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile)
////        UIEdgeInsetsMake(
//        
//        navBarAppearance.setBackgroundImage(image2, for: .default)
//        }
        
        observeNotification()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate
{
    func observeNotification ()
    {
        NotificationCenter.default.addObserver(self, selector:#selector(handleUserLoginNotification(_:)), name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector:#selector(handleUserLogoutNotification(_:)), name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil)
    }
    
    func handleUserLoginNotification (_ notification: Notification)
    {
        //this will only be called if user successfully login
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let naviController = storyBoard.instantiateViewController(withIdentifier: "MainNavigationContoller")
        
        window?.rootViewController = naviController
    }
    
    func handleUserLogoutNotification(_ notification: Notification){
        //this will call when user logout successfully
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        
        window?.rootViewController = viewController
    }
    
}

