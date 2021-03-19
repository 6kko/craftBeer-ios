//
//  Created by Michele Restuccia on 14/3/21.
//

import Foundation

private let percentageFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    return formatter
}()

public extension Double {
    func formattedAsPercentageFor(_ locale: Locale) -> String {
        percentageFormatter.locale = locale
        return percentageFormatter
            .string(from: NSNumber(value: self))!
            .filter { !$0.isWhitespace }
    }
}
