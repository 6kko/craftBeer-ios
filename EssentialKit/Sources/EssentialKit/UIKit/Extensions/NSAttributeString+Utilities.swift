//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit

extension NSAttributedString {
    
    public func settingParagraphStyle(_ style: (NSMutableParagraphStyle) -> ()) -> NSAttributedString {
        let mutableCopy = self.mutableCopy() as! NSMutableAttributedString
        let p = NSMutableParagraphStyle()
        style(p)
        mutableCopy.setParagraphStyle(p)
        return mutableCopy
    }
    
    func nsRangeFor(substring: String) -> NSRange? {
        guard let range = self.string.range(of: substring) else { return nil }
        let lowerBound = range.lowerBound.utf16Offset(in: self.string)
        let upperBound = range.upperBound.utf16Offset(in: self.string)
        return NSRange(location: lowerBound, length: upperBound - lowerBound)
    }
    
    public var bolded: NSAttributedString {
        return bolding(substring: self.string)
    }
    
    public func bolding(substring: String) -> NSAttributedString {
        guard let nsRange = nsRangeFor(substring: substring) else {
            return self
        }
        guard let font = self.attributes(at: 0, longestEffectiveRange: nil, in: nsRange)[.font] as? UIFont else {
            return self
        }
        return modifyingFont(font.bolded(), onSubstring: substring)
    }
    
    func modifyingFont(_ newFont: UIFont, onSubstring: String? = nil) -> NSAttributedString {
        let string = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = {
            if let substring = onSubstring, let nsRange = nsRangeFor(substring: substring) { return nsRange }
            else { return NSRange(location: 0, length: string.length) }
        }()
        string.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (value, range, _) in
            guard let font = value[NSAttributedString.Key.font] as? UIFont else { return }
            let finalNewFont = font.isBold ? newFont.bolded() : newFont
            string.addAttribute(.font, value: finalNewFont, range: range)
        }
        return string
    }
    
    func modifyingColor(_ newColor: UIColor, onSubstring: String? = nil) -> NSAttributedString {
        let string = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = {
            if let substring = onSubstring, let nsRange = nsRangeFor(substring: substring) { return nsRange }
            else { return NSRange(location: 0, length: string.length) }
        }()
        string.removeAttribute(.foregroundColor, range: range)
        string.addAttribute(.foregroundColor, value: newColor, range: range)
        return string
    }
    
    func modifyingBackgroundColor(_ newColor: UIColor, onSubstring: String? = nil) -> NSAttributedString {
        let string = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = {
            if let substring = onSubstring, let nsRange = nsRangeFor(substring: substring) { return nsRange }
            else { return NSRange(location: 0, length: string.length) }
        }()
        string.removeAttribute(.backgroundColor, range: range)
        string.addAttribute(.backgroundColor, value: newColor, range: range)
        return string
    }
}

extension NSMutableAttributedString {
    public func setParagraphStyle(_ style: NSParagraphStyle) {
        self.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: self.length))
    }
    
    func addAttributes(onSubstring substring: String, attrs: [NSAttributedString.Key : Any]) {
        guard let range = self.nsRangeFor(substring: substring) else { fatalError() }
        self.addAttributes(attrs, range: range)
    }
}
