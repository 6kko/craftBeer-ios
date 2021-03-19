//
//  Created by Michele Restuccia on 18/3/21.
//

import UIKit
import EssentialKit

enum Tracking {
    
    enum Event {
        case tap(Tap)
        case featureUsed(FeatureUsed)
        case error(message: String)
        
        enum Tap: String {
            case homeTab, settingTab
        }
        
        enum FeatureUsed {
            case pushNotification
        }
    }
    
    static private let queue = DispatchQueue.main
    
    static func trackEvent(_ event: Event) {
        guard !UIApplication.shared.isRunningTests else { return }
        queue.async { _trackEvent(event) }
    }
    
    static func trackViewController(_ vc: AppModule) {
        guard !UIApplication.shared.isRunningTests else { return }
        queue.async { _trackViewController(vc) }
    }
}

private extension Tracking {
    
    static func _trackEvent(_ event: Event) {
        switch event {
        case .tap(let tap):
            print("**** Track event: \(tap)")

        case .featureUsed(let feature):
            print("**** Track event: \(feature)")
            
        case .error:
            break
        }
    }
    
    static func _trackViewController(_ vc: AppModule) {
        guard let analyticsName  = vc.analyticsName else { return }
        print("**** Track screenName: \(analyticsName)")
    }
}

extension UIButton {
    
    func track(event: Tracking.Event) {
        objc_setAssociatedObject(
            self, &AssociatedObjects.EventWrapper, EventWrapper(event: event), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
        addTarget(self, action: #selector(_onTapForTracking), for: .touchUpInside)
    }
    
    @objc private func _onTapForTracking() {
        guard let wrapper = objc_getAssociatedObject(self, &AssociatedObjects.EventWrapper) as? EventWrapper else { return }
        Tracking.trackEvent(wrapper.event)
    }
    
    private struct AssociatedObjects {
        static var EventWrapper = "EventWrapper"
    }
    
    private class EventWrapper : NSObject {
        let event: Tracking.Event
        init(event: Tracking.Event) {
            self.event = event
        }
    }
}
