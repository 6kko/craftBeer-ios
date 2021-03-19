//
//  Created by Michele Restuccia on 13/3/21.
//

import Foundation
import EssentialKit
import CraftBeerKit
import Task

class StorePreferencesDataSource {
    
    var storePreferences: StorePreferences {
        return readAndParsePreferencesFromBundle()
    }
}

private extension StorePreferencesDataSource {
    func readAndParsePreferencesFromBundle() -> StorePreferences {
        guard let path = Bundle.main.path(forResource: "preferences", ofType: "json"),
              let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let preferences = try? JSONDecoder().decode(StorePreferences.self, from: json) else {
            fatalError()
        }
        return preferences
    }
}
