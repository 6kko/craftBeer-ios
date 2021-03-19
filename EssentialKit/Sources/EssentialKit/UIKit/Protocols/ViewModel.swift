//
//  Created by Michele Restuccia on 6/3/21.
//  Suggested by [PCifani](https://github.com/theleftbit)
//

import UIKit

public protocol ViewModelConfigurable: class {
    associatedtype VM
    func configureFor(viewModel: VM)
}

public protocol ViewModelReusable: ViewModelConfigurable {
    static var reuseType: ReuseType { get }
    static var reuseIdentifier: String { get }
}

extension ViewModelReusable {
    public static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
        
    }
    public static var reuseType: ReuseType {
        return .classReference(self)
    }
}

public enum ReuseType {
    case nib(UINib)
    case classReference(AnyClass)
}
