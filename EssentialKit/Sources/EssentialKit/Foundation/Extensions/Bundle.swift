//
//  Created by Michele Restuccia on 5/3/21.
//

import Foundation

extension Bundle {
    var displayName: String {
        return object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "BSWFoundation"
    }
    
    var appVersion: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    var appBuild: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    
    public var osName: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let osName = "iOS"
        return "\(osName) \(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
}
