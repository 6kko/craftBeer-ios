//
//  Created by Michele Restuccia on 6/3/21.
//

import XCTest
import Task
import Deferred

public extension XCTestCase {
    
    struct UnwrapFail: Swift.Error {}
    struct UnknownValue: Swift.Error {}

    func wait<T, E: Error>(_ task: Task<T>, andExtractError error: E, timeout: TimeInterval = 1) {
        var catchedValue: T!
        var catchedError: Swift.Error!
        let exp = self.expectation(description: "Extract from Future")
        task.upon(.main) { (result) in
            switch result {
            case .failure(let error):
                catchedError = error
            case .success(let value):
                catchedValue = value
            }
            exp.fulfill()
        }
        self.waitForExpectations(timeout: timeout) { (timeoutError) in
            if let timeoutError = timeoutError {
                catchedError = timeoutError
            }
        }
        
        if let _ = catchedValue {
            XCTFail("Should not emit value")
        }
        else {
            XCTAssert(catchedError.reflectedString == error.reflectedString)
        }
    }
    
    func waitAndExtractValue<T>(_ task: Task<T>, timeout: TimeInterval = 1) throws -> T {
        var catchedValue: T!
        var catchedError: Swift.Error!
        let exp = self.expectation(description: "Extract from Future")
        task.upon(.main) { (result) in
            switch result {
            case .failure(let error):
                catchedError = error
            case .success(let value):
                catchedValue = value
            }
            exp.fulfill()
        }
        self.waitForExpectations(timeout: timeout) { (timeoutError) in
            if let timeoutError = timeoutError {
                catchedError = timeoutError
            }
        }
        
        if let error = catchedError {
            throw error
        }
        return catchedValue
    }
}

func given<A>(_ description: String, block: (XCTActivity) throws -> A) rethrows -> A {
    return try XCTContext.runActivity(named: "Given " + description, block: block)
}

func when<A>(_ description: String, block: (XCTActivity) throws -> A) rethrows -> A {
    return try XCTContext.runActivity(named: "When " + description, block: block)
}

func then<A>(_ description: String, block: (XCTActivity) throws -> A) rethrows -> A {
    return try XCTContext.runActivity(named: "Then " + description, block: block)
}

private extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }
}
