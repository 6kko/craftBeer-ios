//
//  Created by Michele Restuccia on 6/3/21.
//

protocol AppModule: UIViewController {
    var shouldShowNotification: Bool { get }
    var analyticsName: String? { get }
}

extension AppModule {
    var shouldShowNotification: Bool { false }
    var analyticsName: String? { nil }
}

import UIKit

enum AppModuleUIKitConfiguration {
    static func initializeApp() {
        swizzleInstanceMethod(
            UIViewController.self,
            from: #selector(UIViewController.viewDidAppear(_:)),
            to: #selector(UIViewController.craftBeer_viewDidAppear)
        )
        swizzleInstanceMethod(
            UIViewController.self,
            from: #selector(UIViewController.viewWillAppear(_:)),
            to: #selector(UIViewController.craftBeer_viewWillAppear(animated:))
        )
    }
}

private extension UIViewController {
    @objc func craftBeer_viewDidAppear(animated: Bool) {
        self.craftBeer_viewDidAppear(animated: animated)
        if let trackableVC = self as? AppModule {
            Tracking.trackViewController(trackableVC)
        }
    }
    
    @objc func craftBeer_viewWillAppear(animated: Bool) {
        self.craftBeer_viewWillAppear(animated: animated)
        addPlainBackButton()
        var barButtonItems: [UIBarButtonItem] = []
        if let notificationBarButtonItem = self.notificationBarButtonItem {
            barButtonItems.append(notificationBarButtonItem)
        }
        if barButtonItems.count > 0 {
            self.navigationItem.rightBarButtonItems = barButtonItems
        }
    }
}

//
//  Swizzle.swift
//  Swizzle
//
//  Created by Yasuhiro Inami on 2014/09/14.
//  Copyright (c) 2014年 Yasuhiro Inami. All rights reserved.
//

import ObjectiveC

private func _swizzleMethod(_ class_: AnyClass, from selector1: Selector, to selector2: Selector, isClassMethod: Bool) {
    let c: AnyClass
    if isClassMethod {
        guard let c_ = object_getClass(class_) else {
            return
        }
        c = c_
    }
    else {
        c = class_
    }
    
    guard let method1: Method = class_getInstanceMethod(c, selector1),
        let method2: Method = class_getInstanceMethod(c, selector2) else
    {
        return
    }
    
    if class_addMethod(c, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
        class_replaceMethod(c, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
    }
    else {
        method_exchangeImplementations(method1, method2)
    }
}

/// Instance-method swizzling.
private func swizzleInstanceMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector) {
    _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: false)
}
