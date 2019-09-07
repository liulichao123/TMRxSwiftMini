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
        
        #warning("observer 是何时释放的， 第一步 通过循环引用保证不销毁")
        // 解释一下：self.run(observer, cancel: disposer)内部执行：
        // sinkAndSubscription.sink 的由来：let sink = AnonymousObservableSink(observer: observer, cancel: disposer)
        // 所以 sinkAndSubscription.sink 的这个sink 内部持有着 observer 和 disposer
        // sink 持有了disposer， 同时，下面👇又把skin设置给disposer, sink和dispoper互相引用 不会销毁
        
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
    
    #warning("observer 是何时释放的， 第二步 通过dispose _sink = nil 打破循环引用，销毁")
    /**
     只有当调用dispose后，观察者observer才会销毁
     onCompleted事件能触发当前订阅的dispose()，能后销毁当前的observer
     */
    func dispose() {
        if _state == false {
            _state = true
            _sink?.dispose() // 在未被订阅时，此时onCompeleted，_sink 尚未设置 ，所以为nil
            _subscription?.dispose()
            
            // _sink = nil 打破sink和dispoper循环引用，自身可以销毁（_sink 是由observer 和 当前这个disposer构成的）
            // let sink = AnonymousObservableSink(observer: observer, cancel: disposer)
            _sink = nil
            _subscription = nil
        } else {
            print("__disposed")
        }
        
    }
    
    deinit {
        print("SinkDisposer deinit")
    }
}
