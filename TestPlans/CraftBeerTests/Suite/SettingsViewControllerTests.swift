//
//  Created by Michele Restuccia on 19/3/21.
//

import XCTest
import Task
@testable import CraftBeer

class SettingsViewControllerTests: CraftBeerSnapshotTests {
    
    func test_layout() {
        let vc = SettingsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        waitABitAndVerify(viewController: navVC)
    }
}
