import Combine
import Foundation

public typealias AnonymousEvent = PassthroughSubject<Void, Never>
public typealias ObservableEvent<T> = PassthroughSubject<T, Never>
public typealias ObservableStream<T> = CurrentValueSubject<T, Never>

@propertyWrapper
public struct Event<T> {
    public var wrappedValue: PassthroughSubject<T, Never>
    public init() { wrappedValue = PassthroughSubject<T, Never>() }
}

public extension Event where T == Void {
    init() { wrappedValue = PassthroughSubject<Void, Never>() }
}

@propertyWrapper
public struct EventStream<T> {
    public var wrappedValue: CurrentValueSubject<T, Never>
    public init(value: T) { wrappedValue = CurrentValueSubject<T, Never>(value) }
}
