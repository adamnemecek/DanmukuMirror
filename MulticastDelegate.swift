//
//  MulticastDelegate.swift
//  Danmuku Mirror
//
//  Recreated by ixan on 2017/1/19.
//  http://www.gregread.com/2016/02/23/multicast-delegates-in-swift/
//
//  Usage:
//  
//  Instead of: weak var delegate: Delegate
//          do: let delegates = MulticastDelegate<Delegate>()
//
//  Instead of: self.delegate.action()
//          do: delegates.invoke { $0.action() }
//
//  Adding Delegate:
//      let dispatcher = Dispatcher()
//      dispatcher.delegates.addDelegate(listener)
//
//  Removing Delegate:
//      dispatcher.delegates.removeDelegate(listener)
//

import Foundation

class MulticastDelegate <T> {
    private var weakDelegates = [WeakWrapper]()
    
    func addDelegate(_ delegate: T) {
        // If delegate is a class, add it to our weak reference array
//        if delegate is AnyObject {
            weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
//        }
            // Delegate being passed is "by value" (not supported)
//        else {
//            fatalError("MulticastDelegate does not support value types")
//        }
    }
    
    func removeDelegate(_ delegate: T) {
        // If delegate is an object, let's loop through weakDelegates to
        // find it.  We
//        if delegate is AnyObject {
            for (index, delegateInArray) in weakDelegates.enumerated().reversed() {
                // If we have a match, remove the delegate from our array
                if delegateInArray.value === (delegate as AnyObject) {
                    weakDelegates.remove(at: index)
                }
            }
//        }
        // Else, it's a value type and we don't need to do anything
    }
    
    func invoke(_ invocation: (T) -> ()) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for (index, delegate) in weakDelegates.enumerated().reversed() {
            // Since these are weak references, "value" may be nil
            // at some point when ARC is 0 for the object.
            if let delegate = delegate.value {
                invocation(delegate as! T)
            }
                // Else, ARC killed it, get rid of the element from our
                // array
            else {
                weakDelegates.remove(at: index)
            }
        }
    }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.addDelegate(right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.removeDelegate(right)
}

private class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
