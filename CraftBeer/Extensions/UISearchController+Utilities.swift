//
//  Created by Michele Restuccia on 6/3/21.
//

import UIKit

extension UISearchController {
    
    public static func withPlaceholder(_ placeholder: String) -> UISearchController {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        UISearchController.customizeSearchBar(searchController.searchBar, placeholder: placeholder)
        return searchController
    }
    
    fileprivate static func customizeSearchBar(_ searchBar: UISearchBar, placeholder: String) {
        searchBar.backgroundImage = .init()
        searchBar.setImage(UIImage(systemName: "magnifyingglass")!, for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .orange
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        guard let textfield = searchBar.getTextField() else { return }
        textfield.attributedPlaceholder = regularTextStyler.attributedString(
            placeholder, color: .brownGreyThree, forStyle: .footnote
        )
    }
}

public extension UISearchBar {
    
    static func withPlaceholder(_ placeholder: String) -> UISearchBar {
        let sb = UISearchBar()
        UISearchController.customizeSearchBar(sb, placeholder: placeholder)
        return sb
    }
    
    func getTextField() -> UITextField! {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return value(forKey: "searchField") as? UITextField
        }
    }
}
