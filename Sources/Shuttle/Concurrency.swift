import Combine
import Foundation

@propertyWrapper
public struct MainThreaded {
    var action: Action?
    
    public var wrappedValue: Action {
        get {{
            DispatchQueue.main.async { action?() }
        }}
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct BackgroundThreaded {
    var action: Action?
    
    public var wrappedValue: Action {
        get {
            return {
                DispatchQueue.global(qos: .background).async { self.action?() }
            }
        }
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct UserInitiatedThreaded {
    var action: Action?
    
    public var wrappedValue: Action {
        get {
            return {
                DispatchQueue.global(qos: .userInitiated).async { self.action?() }
            }
        }
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct UtilityThreaded {
    var action: Action?
    
    public var wrappedValue: Action {
        get {
            return {
                DispatchQueue.global(qos: .utility).async { self.action?() }
            }
        }
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct DefaultThreaded {
    var action: Action?
    
    public var wrappedValue: Action {
        get {
            return {
                DispatchQueue.global(qos: .default).async { self.action?() }
            }
        }
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action) {
        self.wrappedValue = wrappedValue
    }
}
