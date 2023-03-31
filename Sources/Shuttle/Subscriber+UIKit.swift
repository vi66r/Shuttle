#if canImport(UIKit)
import UIKit

public extension Subscribing where Self: UIViewController {
    var prefersMainThreadExecution: Bool { true }
}

public extension Subscribing where Self: UIView {
    var prefersMainThreadExecution: Bool { true }
}
#endif
