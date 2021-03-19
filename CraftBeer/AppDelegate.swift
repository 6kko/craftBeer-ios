//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit
import CraftBeerKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    private var sceneManager: SceneManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        SceneManager.themeApp()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        defer { self.window?.makeKeyAndVisible() }
        
        guard NSClassFromString("XCTest") == nil else {
            self.window?.rootViewController = UIViewController()
            return true
        }

        Current = .init(environment: .init(host: .production, country: .spain))
        
        sceneManager = SceneManager(window: self.window!)
        sceneManager.updateRootViewController()
        return true
    }
}
