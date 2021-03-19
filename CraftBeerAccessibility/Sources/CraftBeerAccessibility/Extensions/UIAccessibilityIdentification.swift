//
//  Created by Michele Restuccia on 19/3/21.
//

import UIKit

public extension UITabBarItem {
    func setCraftBeerIdentifier(_ i: Identifiers.TabBarItems) {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIButton {
    func setCraftBeerIdentifier(_ i: Identifiers.Buttons) {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIBarButtonItem {
    func setCraftBeerIdentifier(_ i: Identifiers.Buttons) {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIViewController {
    func setCraftBeerIdentifier(_ i: Identifiers.ViewControllers) {
        view.accessibilityIdentifier = i.rawValue
    }
}

public extension UIView {
    func setCraftBeerIdentifier<T: RawRepresentable>(_ i: T) where T.RawValue == String {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIBarItem {
    func setCraftBeerIdentifier<T: RawRepresentable>(_ i: T) where T.RawValue == String {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIImage {
    func setCraftBeerIdentifier<T: RawRepresentable>(_ i: T) where T.RawValue == String {
        accessibilityIdentifier = i.rawValue
    }
}

public extension UIAlertAction {
    func setCraftBeerIdentifier<T: RawRepresentable>(_ i: T) where T.RawValue == String {
        accessibilityValue = i.rawValue
    }
}

public extension UIContextualAction {
    func setCraftBeerIdentifier<T: RawRepresentable>(_ i: T) where T.RawValue == String {
        accessibilityLabel = i.rawValue
    }
}
