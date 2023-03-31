import Combine
import Foundation

public protocol Subscribing {
    var cancellables: Set<AnyCancellable> { get set }
    var prefersMainThreadExecution: Bool { get }
}

public extension Subscribing {
    mutating func subscribe<T>(to subject: ObservableEvent<T>, performing action: @escaping ((T) -> Void)) {
        if prefersMainThreadExecution {
            subscribeOnMain(to: subject, performing: action)
        } else {
            subscribeOnSenderThread(to: subject, performing: action)
        }
    }
    
    mutating func subscribe<T>(to stream: ObservableStream<T>, performing action: @escaping ((T) -> Void)) {
        if prefersMainThreadExecution {
            subscribeOnMain(to: stream, performing: action)
        } else {
            subscribeOnSenderThread(to: stream, performing: action)
        }
    }
    
    mutating func subscribeOnSenderThread<T>(to subject: ObservableEvent<T>, performing: @escaping ((T) -> Void)) {
        subject.sink(receiveValue: performing).store(in: &cancellables)
    }
    
    mutating func subscribeOnMain<T>(to subject: ObservableEvent<T>, performing: @escaping ((T) -> Void)) {
        subject.receive(on: DispatchQueue.main).sink(receiveValue: performing).store(in: &cancellables)
    }
    
    mutating func subscribeOnSenderThread<T>(to stream: ObservableStream<T>, performing: @escaping ((T) -> Void)) {
        stream.sink(receiveValue: performing).store(in: &cancellables)
    }
    
    mutating func subscribeOnMain<T>(to stream: ObservableStream<T>, performing: @escaping ((T) -> Void)) {
        stream.receive(on: DispatchQueue.main).sink(receiveValue: performing).store(in: &cancellables)
    }
}
