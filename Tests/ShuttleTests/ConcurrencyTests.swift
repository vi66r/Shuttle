@testable import Shuttle
import XCTest

class ConcurrencyTests: XCTestCase {
    
    var mainThreaded: MainThreaded!
    var backgroundThreaded: BackgroundThreaded!
    var userInitiatedThreaded: UserInitiatedThreaded!
    var utilityThreaded: UtilityThreaded!
    var defaultThreaded: DefaultThreaded!

    override func setUp() {
        super.setUp()
        mainThreaded = MainThreaded(wrappedValue: {})
        backgroundThreaded = BackgroundThreaded(wrappedValue: {})
        userInitiatedThreaded = UserInitiatedThreaded(wrappedValue: {})
        utilityThreaded = UtilityThreaded(wrappedValue: {})
        defaultThreaded = DefaultThreaded(wrappedValue: {})
    }

    override func tearDown() {
        mainThreaded = nil
        backgroundThreaded = nil
        userInitiatedThreaded = nil
        utilityThreaded = nil
        defaultThreaded = nil
        super.tearDown()
    }

    func testMainThreaded() {
        let expectation = self.expectation(description: "Closure executed on main thread")
        mainThreaded.action = {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        mainThreaded.wrappedValue()
        wait(for: [expectation], timeout: 1)
    }

    func testBackgroundThreaded() {
        let expectation = self.expectation(description: "Closure executed on background thread")
        backgroundThreaded.action = {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        backgroundThreaded.wrappedValue()
        wait(for: [expectation], timeout: 1)
    }

    func testUserInitiatedThreaded() {
        let expectation = self.expectation(description: "Closure executed on user-initiated thread")
        userInitiatedThreaded.action = {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        userInitiatedThreaded.wrappedValue()
        wait(for: [expectation], timeout: 1)
    }

    func testUtilityThreaded() {
        let expectation = self.expectation(description: "Closure executed on utility thread")
        utilityThreaded.action = {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        utilityThreaded.wrappedValue()
        wait(for: [expectation], timeout: 1)
    }

    func testDefaultThreaded() {
        let expectation = self.expectation(description: "Closure executed on default thread")
        defaultThreaded.action = {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        defaultThreaded.wrappedValue()
        wait(for: [expectation], timeout: 1)
    }

}
