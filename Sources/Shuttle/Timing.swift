import Combine
import Foundation

@propertyWrapper
public struct Delayed {
    var action: Action?
    var milliseconds: Int
    var thread: DispatchQueue
    
    public var wrappedValue: Action {
        get {{
            thread.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: {
                action?()
            })
        }}
        set { action = newValue }
    }
    
    public init(wrappedValue: @escaping Action, _ delay: Int, thread: DispatchQueue = .main) {
        milliseconds = delay
        self.thread = thread
        self.wrappedValue = wrappedValue
    }
}

//func repeatedlyPerform(_ action: @escaping Action,
//                              every delay: Int,
//                              until predicate: @escaping (() -> Bool) = { false }) {
//    let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delay), repeats: true) { timer in
//        action()
//        if predicate() { timer.invalidate() }
//    }
//}
