# Shuttle

Shuttle is a nano-library designed to act mostly as syntactic sugar for certain concurrency features within Swift. 

Namely, it takes `Combine` and adapts it's concepts of publishers into "Events" for the sake of readability and just overall speed. It also introduces a series of typealiases that represent generic closures, allowing you to more easily treat functions as a type, and pass them around with relative freedom.

The following is a series of examples on how you might leverage the contents of this library.  

## Event - Subscriber Pattern

`@Event` is actually a property wrapper, which, depending on whether or not a type is supplied through the generics interface, will produce a `PassthroughSubject<T, Never>`. This isn't intended to wholly replace PassthroughSubject, or the use of Subjects in Combine entirely, but rather be a more convenient interface for passing events to a subscriber. Some parts are _very_ similar to the `@Published` property wrapper, and you can actually use that as an alternative.

The counterpart to `@Event` is the `Subscribing` protocol, which provides a host of methods following the `subscribe(to:<#Event>, performing:<#TypedAction<T>>)` pattern. This is designed to let you very quickly subscribe to the events without having to jump through the hoops of `sink` and `store`. The `Subscribing` protocol also requires a boolean `prefersMainThreadExecution` which allows the subscriber to determine whether it should receive events on the main thread, or the sender's thread. By default, `UIViewController` and `UIView` types (in iOS) will have this flipped on when conforming to `Subscribing`. 

### Creating `@Event`s

```swift
class Combobulator {
    @Event var refreshEvent
    @Event<String> var flubberBatchName
    @EventStream<Int>(value: 0) var flubberCount

    func loadFlubbers() {
        Task {
            do {
                let flubbers = try await loadFlubbers()
                flubberBatchName.send(flubbers.batchName)
                flubberCount.value = flubbers.count
                try await combobulate(flubbers) 
                refreshEvent.send()
            } catch {
                exit(0) // lol don't ever do this.
            }
        }
    }

    func combobulate(_ flubbers: [Flubber]) {   
        ...
    }
}
```

### Subscribing

```swift
class FlubberDisplay: Subscribing {

    let prefersMainThreadExecution = true
    
    let combobulator = Combobulator()
    
    init() {
        subscribe(to: combobulator.refreshEvent, performing:refresh)
        subscribe(to: combobulator.flubberBatchName, performing:updateBatchName(to:))
        subscribe(to: combobulator.flubberCount, performing:updateFlubberCount(to:))
    }
    
    func refresh() {
        ...
    }
    
    func updateBatchName(to name: String) {
        ...
    }
    
    func udpateFlubberCount(to count: Int) {
        ...
    }   
}
```

## Threading Property Wrappers

Literally property wrappers to allow for execution on certain threads like so:

```swift
@MainThreaded var action = { [weak self] in
    self?.someUILabel.text = someNewValue
    print("executed on main thread")
}
action()
```

There's also the `@Delayed` wrapper which performs some `Action` with a delay on a given thread. If no thread is supplied, it will run on `main` by default.

```swift
@Delayed2(500) var action = {
    print("do something")
}
action()

@Delayed2(500, thread: .global(qos: .background)) var backgroundAction = {
print("do something")
}
backgroundAction()
```

The ways you can use this nano-library are rather extensive, because what it does is relatively low level. One potential use case is with the MVVM architecture, where the _Event-Subscriber_ pattern above can drastically cut down on the work you need to do between ViewControllers and ViewModels, while also enforcing thread safety.

Made with ❤️ on Long Island.

<img src="https://img.icons8.com/tiny-color/512/twitter.png"  width="12" height="12"> [Connect?](https://twitter.com/definitelyrafi)
