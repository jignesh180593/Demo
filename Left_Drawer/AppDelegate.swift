//
//  AppDelegate.swift
//  Left_Drawer
//
//  Created by Romal Tandel on 9/25/17.
//  Copyright © 2017 Romal Tandel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UINavigationBar.appearance().barTintColor = UIColor.blue//407263
        UINavigationBar.appearance().barTintColor = UIColor(red: 40/255, green: 120/255, blue: 60/255, alpha: 1)//uicolorFromHex(rgbValue: 0x00FF00)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "126463484500-6qef4s5r50u400ifhbsosdktdrrrpq8j.apps.googleusercontent.com"
        
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsDoctorLogin){
            showDoctorDashboard()
        }
        return true
    }
    func showDoctorDashboard() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DoctorDashboardViewController") as! DoctorDashboardViewController
        
        var navigationController = UINavigationController()
       
        navigationController = UINavigationController(rootViewController: dashboardViewController)
        
        //It removes all view controllers from the navigation controller then sets the new root view controller and it pops.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        //Navigation bar is hidden
        navigationController.isNavigationBarHidden = true
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
    //For facebook login
    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("fb\(Settings.appID!)")
        let isFBURL = ((url.scheme?.hasPrefix("fb\(Settings.appID!)"))! && url.host == "authorize")
        if  isFBURL == true {
            guard let source = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String else { return false }
            let annotation = options[UIApplication.OpenURLOptionsKey.annotation] as? String
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: source, annotation: annotation)
        }
        return false
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let _ = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String {
            return ApplicationDelegate.shared.application(application,
                                                                         open: url,
                                                                         sourceApplication: sourceApplication,
                                                                         annotation: annotation)
        }
        return false
    }
    //end

    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}

