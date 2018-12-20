//
//  Producer.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation
class Producer<Element> : Observable<Element> {
    override init() {
        super.init()
    }
    
    override func subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        let disposer = SinkDisposer()
        let sinkAndSubscription = self.run(observer, cancel: disposer)
        disposer.setSinkAndSubscription(sink: sinkAndSubscription.sink, subscription: sinkAndSubscription.subscription)
        
        return disposer
    }
    
    func run<O : ObserverType>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where O.E == Element {
        rxAbstractMethod()
    }
}

fileprivate final class SinkDisposer: Cancelable {
    fileprivate enum DisposeState: Int32 {
        case disposed = 1
        case sinkAndSubscriptionSet = 2
    }
    
    private var _state = false
    private var _sink: Disposable? = nil
    private var _subscription: Disposable? = nil
    
    private var hasSet = false
    
    var isDisposed: Bool {
        return _state
    }
    
    func setSinkAndSubscription(sink: Disposable, subscription: Disposable) {
        if hasSet == false {
            hasSet = true
            _sink = sink
            _subscription = subscription
        }
    }
    
    func dispose() {
        if _state == false {
            _state = true
            _sink?.dispose()
            _subscription?.dispose()
            
            _sink = nil
            _subscription = nil
        } else {
            print("__disposed")
        }
        
    }
}
