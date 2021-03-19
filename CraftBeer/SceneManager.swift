//
//  Created by Michele Restuccia on 7/3/21.
//

import UIKit
import EssentialKit
import IQKeyboardManagerSwift

class SceneManager {
    
    private let window: UIWindow
    private var rootViewController: ContainerViewController? {
        return self.window.rootViewController as? ContainerViewController
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func updateRootViewController() {
        let newViewController = NaturitasTabBarController()
        if let rootViewController = self.rootViewController {
            rootViewController.updateContainedViewController(newViewController)
        } else {
            window.rootViewController = ContainerViewController(containedViewController: newViewController)
        }
    }
    
    static func themeApp() {
        
        AppModuleUIKitConfiguration.initializeApp()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderFont = mediumTextStyler.fontForStyle(.callout)
        IQKeyboardManager.shared.toolbarTintColor = .orange
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.orange
        UITabBar.appearance().tintColor = .orange
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: UIFont(descriptor: regularTextStyler.fontDescriptor!, size: 11)],
            for: .selected
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: UIFont(descriptor: regularTextStyler.fontDescriptor!, size: 11)],
            for: .normal
        )
        UINavigationBar.appearance().tintColor = .craftBeerTextTitleColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.craftBeerTextTitleColor,
            .font: boldTextStyler.fontForStyle(.callout),
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .foregroundColor : UIColor.orange,
            .font: mediumTextStyler.fontForStyle(.subheadline),
        ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .foregroundColor : UIColor.lightGray,
            .font: mediumTextStyler.fontForStyle(.subheadline),
        ], for: .disabled)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .foregroundColor : UIColor.orange,
            .font: mediumTextStyler.fontForStyle(.subheadline),
        ], for: .highlighted)
        UIButton.appearance().tintColor = .craftBeerTintColor
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.brownGreyThree.withAlphaComponent(0.4)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.brownGreyThree
        PhotoGalleryViewController.Appearance.BackgroundColor = .craftBeerSecondaryBackgroundColor
        PhotoGalleryViewController.Appearance.TintColor = .orange
        
        RandomColorFactory.isOn = false
        RandomColorFactory.defaultColor = .whiteSmoke
        ErrorView.Appereance.Spacing = 16
        UIViewController.loadingViewFactory = { UIView.craftBeerLoadingView() }

        /// We are too lazy to do this properly
        let textStylers: [TextStyler] = [mediumTextStyler, regularTextStyler, boldTextStyler]
        textStylers.forEach { (ts) in
            ts.minContentSizeSupported = .small
            ts.maxContentSizeSupported = .extraLarge
        }
    }
}

class NaturitasTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    enum Tags: Int {
        case beerList, settings
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        
        let homeVC: (UIViewController, UITabBarItem) = (
            BeerListViewController(),
            UITabBarItem(
                title: "tabbar-beer-list".localized,
                image: UIImage.craftBeerIcon(.home).scaleTo(.init(width: 20, height: 20)),
                tag: Tags.beerList.rawValue
            )
        )
        
        let settingsVC: (UIViewController, UITabBarItem) = (
            SettingsViewController(),
            UITabBarItem(
                title: "tabbar-settings".localized,
                image: UIImage.craftBeerIcon(.settings).scaleTo(.init(width: 20, height: 20)),
                tag: Tags.settings.rawValue
            )
        )
        
        viewControllers = [
            navigationController(with: homeVC),
            navigationController(with: settingsVC),
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private
    
    private func navigationController(with tuple:(UIViewController, UITabBarItem)) -> UIViewController {
        let navVC = UINavigationController(rootViewController: tuple.0)
        navVC.tabBarItem = tuple.1
        return navVC
    }
    
    //MARK: UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        trackingTabbarClickEvent(viewController.tabBarItem.tag)
        return true
    }
    
    private func trackingTabbarClickEvent(_ tag: Int) {
        switch Tags(rawValue: tag) {
        case .beerList:
            Tracking.trackEvent(.tap(.homeTab))
        case .settings:
            Tracking.trackEvent(.tap(.settingTab))
        default:
            break
        }
    }
}
