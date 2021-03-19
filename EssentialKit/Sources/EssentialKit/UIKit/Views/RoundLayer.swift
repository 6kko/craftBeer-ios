//
//  Created by Michele Restuccia on 6/3/21.
//

import UIKit
public class RoundLayer: CALayer {
    
    override init() {
        super.init()
        masksToBounds = true
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        masksToBounds = true
    }
    
    override public var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var cornerRadius: CGFloat {
        get {
            return self.frame.size.width/2
        } set {
            fatalError()
        }
    }
}
