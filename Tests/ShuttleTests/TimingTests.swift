@testable import Shuttle
import XCTest

class DelayedTests: XCTestCase {
    
    func testDelayedPropertyWrapper() {
        let expectation = XCTestExpectation(description: "Delayed property wrapper test")
        
        var value = false
        
        @Delayed(100) var flip = {
            value = true
        }
        flip()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            XCTAssertEqual(value, true)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1)
    }
}

