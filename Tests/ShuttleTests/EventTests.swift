import Combine
import XCTest
@testable import Shuttle

class EventTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testEvent() {
        let event = Event<String>()
        let expectation = self.expectation(description: "Event received value")
        event.wrappedValue.sink { value in
            XCTAssertEqual(value, "Test")
            expectation.fulfill()
        }.store(in: &cancellables)
        event.wrappedValue.send("Test")
        wait(for: [expectation], timeout: 1)
    }

    func testVoidEvent() {
        let event = Event<Void>()
        let expectation = self.expectation(description: "Void event received")
        event.wrappedValue.sink {
            expectation.fulfill()
        }.store(in: &cancellables)
        event.wrappedValue.send(())
        wait(for: [expectation], timeout: 1)
    }

    func testEventStream() {
        let eventStream = EventStream<String>(value: "Initial value")
        let expectation = self.expectation(description: "Event stream received value")
        eventStream.wrappedValue.dropFirst().sink { value in
            XCTAssertEqual(value, "New value")
            expectation.fulfill()
        }.store(in: &cancellables)
        eventStream.wrappedValue.send("New value")
        wait(for: [expectation], timeout: 1)
    }
}
