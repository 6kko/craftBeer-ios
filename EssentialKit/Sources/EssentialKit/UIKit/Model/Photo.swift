//
//  Created by Michele Restuccia on 6/3/21.
//  Suggested by [PCifani](https://github.com/theleftbit)
//

import UIKit
import Nuke

public struct Photo {
    
    public enum Kind {
        case url(Foundation.URL, placeholderImage: PlaceholderImage?)
        case image(UIImage)
        case empty
    }
    
    public let kind: Kind
    public let averageColor: UIColor
    public let size: CGSize?
    public let preferredContentMode: UIView.ContentMode?
    
    public init(kind: Kind, averageColor: UIColor = UIColor.randomColor(), size: CGSize? = nil, preferredContentMode: UIView.ContentMode? = nil) {
        self.kind = kind
        self.averageColor = averageColor
        self.preferredContentMode = preferredContentMode
        self.size = size
    }
    
    public init(image: UIImage, averageColor: UIColor = UIColor.randomColor(), preferredContentMode: UIView.ContentMode? = nil) {
        self.kind = .image(image)
        self.averageColor = averageColor
        self.preferredContentMode = preferredContentMode
        self.size = image.size
    }
    
    public init(url: URL?, averageColor: UIColor = UIColor.randomColor(), placeholderImage: PlaceholderImage? = nil, size: CGSize? = nil, preferredContentMode: UIView.ContentMode? = nil) {
        self.kind = (url == nil) ? .empty : .url(url!, placeholderImage: placeholderImage)
        self.averageColor = averageColor
        self.preferredContentMode = preferredContentMode
        self.size = size
    }
    
    public static func emptyPhoto() -> Photo {
        return Photo(kind: .empty, averageColor: UIColor.randomColor(), size: nil)
    }
}

public enum RandomColorFactory {
    
    public static var isOn: Bool = true
    public static var defaultColor = UIColor.init(r: 255, g: 149, b: 0)
    
    public static func randomColor() -> UIColor {
        guard isOn else {
            return defaultColor
        }
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

public extension Photo {
    var estimatedSize: CGSize? {
        guard size == nil else {
            return size
        }
        
        return self.uiImage?.size
    }
    
    var uiImage: UIImage? {
        switch self.kind {
        case .empty:
            return nil
        case .image(let image):
            return image
        case .url(let url, _):
            let imageCache = Nuke.ImageCache.shared //This dependency should be removed
            guard let request = imageCache[ImageRequest(url: url)] else {
                return nil
            }
            return request.image
        }
    }
    
    var url: URL? {
        switch self.kind {
        case .empty:
            return nil
        case .image:
            return nil
        case .url(let url, _):
            return url
        }
    }
}

public extension Photo {
    struct PlaceholderImage {
        public let image: UIImage
        public let preferredContentMode: UIView.ContentMode
        public init(image: UIImage, preferredContentMode: UIView.ContentMode) {
            self.image = image
            self.preferredContentMode = preferredContentMode
        }
    }
}

extension CGSize: Hashable { // For some reason `CGSize` isn't `Hashable`
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
extension Photo: Equatable, Hashable {}
extension Photo.Kind: Equatable, Hashable {}
extension Photo.PlaceholderImage: Equatable, Hashable {}
