import Foundation

public typealias Action = (()->Void)
public typealias TypedAction<T> = ((T?)->Void)
public typealias Typed2DAction<T, X> = ((T?, X?)->Void)
public typealias MultiAction<T> = ((_ args: T?...)->Void)?
