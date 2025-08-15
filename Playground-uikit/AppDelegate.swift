//
//  AppDelegate.swift
//  Playground-uikit
//
//  Created by Mekala Prudhvi Reddy on 20/05/25.
//

import UIKit
import mParticle_Apple_SDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MParticle.sharedInstance().rokt.events("RoktLayout", onEvent: { roktEvent in
            if let event = roktEvent as? MPRoktEvent.MPRoktInitComplete {
                print("Rokt init completed with status: \(event.success)")
            } else if let event = roktEvent as? MPRoktEvent.MPRoktShowLoadingIndicator {

            } else if let event = roktEvent as? MPRoktEvent.MPRoktHideLoadingIndicator {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPlacementInteractive {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPlacementReady {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktOfferEngagement {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktOpenUrl {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPositiveEngagement {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPlacementClosed {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPlacementCompleted {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktPlacementFailure {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktFirstPositiveEngagement {
                
            } else if let event = roktEvent as? MPRoktEvent.MPRoktCartItemInstantPurchase {
                
            }
        })
        
        let options = MParticleOptions(key: "key",
        secret: "") // TODO intentionally left empty. Please fill it.
        options.environment = .development
        options.logLevel = .debug

        MParticle.sharedInstance().start(with: options)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

