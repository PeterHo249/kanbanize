//
//  AppDelegate.swift
//  kanbanize
//
//  Created by Peter Ho on 4/17/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UISplitViewControllerDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let userHasOnboardedAlready = UserDefaults.standard.bool(forKey: "user_has_onboarded")
        if userHasOnboardedAlready == false {
            self.window?.rootViewController = self.generateStandardOnboardingVC()
        }
        return true
    }
    
    func generateStandardOnboardingVC() -> OnboardingViewController {
        let firstPage = OnboardingContentViewController(title: "Add new board", body: "Starting a new project with a board!", image: UIImage(named: "new-board"), buttonText: nil, action: nil)
        let secondPage = OnboardingContentViewController(title: "Swipe To Move", body: "Swipe your task left and right to change its status.", image: UIImage(named: "swipe"), buttonText: nil, actionBlock: nil)
        let thirdPage = OnboardingContentViewController(title: "Statictics", body: "View your work process with a pie chart.", image: UIImage(named: "chart"), buttonText: nil, actionBlock: nil)
        let fourthPage = OnboardingContentViewController(title: "Extension", body: "View your upcoming task with a extension.", image: UIImage(named: "extension"), buttonText: "Get Started") {
            () -> Void in
            self.handleOnboardingCompletion()
        }
        
        let onboardVC:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "onboard-background"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        
        onboardVC.shouldBlurBackground = true
        onboardVC.shouldFadeTransitions = true
        onboardVC.fadePageControlOnLastPage = true
        onboardVC.fadeSkipButtonOnLastPage = true
        
        onboardVC.allowSkipping = true
        onboardVC.skipHandler = { () -> Void in
            self.handleOnboardingCompletion()
        }
        
        return onboardVC
    }
   
    func handleOnboardingCompletion() {
        UserDefaults.standard.set(true, forKey: "user_has_onboarded")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateInitialViewController()
        self.window?.rootViewController = mainVC
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
        // Saves changes in the application's managed object context before the application terminates.
        DB.Save()
    }

}

