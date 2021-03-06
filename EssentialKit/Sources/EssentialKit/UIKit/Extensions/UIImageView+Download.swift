//
//  Created by Michele Restuccia on 7/3/21.
//

import Task
import Nuke
import UIKit

public typealias ImageCompletionBlock = (Task<UIImage>.Result) -> Void

extension UIImageView {
    
    public static var fadeImageDuration: TimeInterval? = nil
    
    private static var webDownloadsEnabled = true
    
    static public func disableWebDownloads() {
        webDownloadsEnabled = false
    }
    
    static public func enableWebDownloads() {
        webDownloadsEnabled = true
    }
    
    public func setImageFromURLString(_ url: String) {
        if let url = URL(string: url) {
            setImageWithURL(url)
        }
    }
    
    public func cancelImageLoadFromURL() {
        Nuke.cancelRequest(for: self)
    }
    
    @nonobjc
    public func setImageWithURL(_ url: URL, completed completedBlock: ImageCompletionBlock? = nil) {
        guard UIImageView.webDownloadsEnabled else { return }
        
        let options = ImageLoadingOptions(
            transition: (UIImageView.fadeImageDuration != nil) ? .fadeIn(duration: UIImageView.fadeImageDuration!) : nil
        )
        Nuke.loadImage(with: url, options: options, into: self, progress: nil) { (result) in
            let taskResult: Task<UIImage>.Result
            switch result {
            case .failure(let error):
                taskResult = .failure(error)
            case .success(let response):
                taskResult = .success(response.image)
            }
            completedBlock?(taskResult)
        }
    }
    
    @nonobjc
    public func setPhoto(_ photo: Photo) {
        if let preferredContentMode = photo.preferredContentMode {
            contentMode = preferredContentMode
        }
        switch photo.kind {
        case .image(let image):
            self.image = image
        case .url(let url, let _placeholderImage):
            if let placeholderImage = _placeholderImage {
                image = placeholderImage.image
                contentMode = placeholderImage.preferredContentMode
            }
            backgroundColor = photo.averageColor
            setImageWithURL(url) { result in
                switch result {
                case .failure:
                    if let placeholderImage = _placeholderImage {
                        self.image = placeholderImage.image
                        self.contentMode = placeholderImage.preferredContentMode
                    }
                case .success:
                    if let preferredContentMode = photo.preferredContentMode {
                        self.contentMode = preferredContentMode
                    }
                    self.backgroundColor = nil
                }
            }
        case .empty:
            image = nil
            backgroundColor = photo.averageColor
        }
    }
    
    public static func prefetchImagesAtURL(_ urls: [URL]) {
        preheater.startPreheating(with: urls)
    }
}

private let preheater = Nuke.ImagePreheater(destination: .diskCache)
