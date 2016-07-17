//
//  AppDelegate.swift
//  hackerbooks
//
//  Created by Fran on 3/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let json = constructJSON()
        
        if let books = json{
                
            let library : Library = Library(jsonArray:books)
            library.addFavorites()
                
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    
                let libraryVC = LibraryTableViewController(library: library)
                    
                let navLib = UINavigationController(rootViewController: libraryVC)
                libraryVC.delegate = libraryVC
                    
                window?.rootViewController = navLib
                    
            }else{
                
                let libraryVC = LibraryTableViewController(library: library)
                
                let book : Book = library.booksForTag(libraryVC.keyforSection(1))![0]
                let bookVC = BookViewController(model:book)
                
                libraryVC.delegate = bookVC
                    
                let navLib = UINavigationController(rootViewController: libraryVC)
                let navBook = UINavigationController(rootViewController: bookVC)
                
                let splitVc = UISplitViewController()
                splitVc.viewControllers = [navLib, navBook]
                    
                window?.rootViewController = splitVc
            }
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

