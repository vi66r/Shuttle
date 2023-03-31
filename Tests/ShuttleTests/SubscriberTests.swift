@testable import Shuttle
import XCTest
import Combine

class ObservableTests: XCTestCase {
    
    struct TestEvent {
        let value: Int
    }
    
    let testEvent1 = TestEvent(value: 1)
    let testEvent2 = TestEvent(value: 2)
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
    }
    
    func testSubscribeOnSenderThread() {
        let subject = ObservableEvent<TestEvent>()
        let expectation = self.expectation(description: "Expect to receive event on sender thread")
        
        var subscriber = TestSubscriber()
        subscriber.subscribeOnSenderThread(to: subject) { event in
            XCTAssertEqual(event.value, self.testEvent1.value)
            XCTAssertTrue(Thread.isMainThread == false)
            expectation.fulfill()
        }
        
        DispatchQueue.global(qos: .background).async {
            subject.send(self.testEvent1)
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    #if canImport(UIKit)
    func testSubscribeOnMain() {
        let subject = ObservableEvent<TestEvent>()
        let expectation = self.expectation(description: "Expect to receive event on main thread")
        
        var subscriber = TestViewControllerSubscriber()
        subscriber.subscribeOnMain(to: subject) { event in
            XCTAssertEqual(event.value, self.testEvent2.value)
            XCTAssertTrue(Thread.isMainThread == true)
            expectation.fulfill()
        }
        
        DispatchQueue.global(qos: .background).async {
            subject.send(self.testEvent2)
        }
        
        wait(for: [expectation], timeout: 1)
    }
    #endif
    
    func testSubscribeToEvent() {
        let subject = ObservableEvent<TestEvent>()
        let expectation = self.expectation(description: "Expect to receive event")
        
        var subscriber = TestSubscriber()
        subscriber.subscribe(to: subject) { event in
            XCTAssertEqual(event.value, self.testEvent1.value)
            expectation.fulfill()
        }
        
        subject.send(testEvent1)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSubscribeToStream() {
        let subject = ObservableStream<TestEvent>(testEvent1)
        let expectation = self.expectation(description: "Expect to receive event")
        
        var subscriber = TestSubscriber()
        subscriber.subscribe(to: subject) { event in
            XCTAssertEqual(event.value, self.testEvent1.value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

class TestSubscriber: Subscribing {
    var cancellables = Set<AnyCancellable>()
    var prefersMainThreadExecution: Bool = false
}

#if canImport(UIKit)

class TestViewControllerSubscriber: UIViewController, Subscribing {
    var cancellables = Set<AnyCancellable>()
}

class TestViewSubscriber: UIView, Subscribing {
    var cancellables = Set<AnyCancellable>()
}

#endif
