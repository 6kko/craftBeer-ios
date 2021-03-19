//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit

extension UIView {
    
    public func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    @discardableResult
    public func pinToSuperview(withEdges edges: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superView = superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: edges.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -edges.right),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: edges.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -edges.bottom)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    public func pinToSuperviewLayoutMargins() -> [NSLayoutConstraint] {
        guard let superView = superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false
        
        let guide = superView.layoutMarginsGuide
        let constraints: [NSLayoutConstraint] = [
            leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            topAnchor.constraint(equalTo: guide.topAnchor),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    public func pinToSuperviewSafeLayoutEdges(withMargin margin: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superView = superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: margin.left),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -margin.right),
            safeAreaLayoutGuide.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: margin.top),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -margin.bottom)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    public func removeAllConstraints() {
        let previousConstraints = constraints
        NSLayoutConstraint.deactivate(previousConstraints)
        removeConstraints(previousConstraints)
    }
    
    public func roundCorners(radius: CGFloat = 10, isContinuous: Bool = true) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        if #available(iOS 13.0, *), isContinuous {
            layer.cornerCurve = .continuous
        }
    }
    
    @discardableResult
    public func centerInSuperview() -> [NSLayoutConstraint] {
        guard let superView = superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    public func dontMakeBiggerOrSmaller() {
        dontMakeBiggerOrSmallerVertically()
        dontMakeBiggerOrSmallerHorizontally()
    }
    
    public func dontMakeBiggerOrSmallerVertically() {
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    public func dontMakeBiggerOrSmallerHorizontally() {
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

public extension UIView {
    
    static func separatorView(_ color: UIColor = .gray) -> UIView {
        let view = UIView.withBackgroundColor(color)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    static func withBackgroundColor(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
