//
//  Observable.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

public class Observable<Element> : ObservableType {
    /// Type of elements in sequence.
    public typealias E = Element
    
    init() { }
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        //抽象方法
        rxAbstractMethod()
    }
    
    public func asObservable() -> Observable<E> {
        return self
    }
    
}

extension ObservableType {

    public func subscribe(_ on: @escaping (Event<E>) -> Void) -> Disposable {
        let observer = AnonymousObserver { e in
            on(e)
        }
        return self.asObservable().subscribe(observer)
    }
    
    // 真正的订阅方法
    public func subscribe(onNext: ((E) -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil)
        -> Disposable {
            
            let disposable: Disposable
            
            if let disposed = onDisposed {
                disposable = Disposables.create(with: disposed)
            } else {
                disposable = Disposables.create()
            }
            
            let eventBlock: (Event<E>) -> Void = { event in
                switch event {
                case .next(let value):
                    onNext?(value)
                case .error(let error):
                    if let onError = onError {
                        onError(error)
                    }
                    else {
                        print("错误未处理：", error)
                    }
                    disposable.dispose()
                case .completed:
                    onCompleted?()
                    disposable.dispose()
                }
            }
            //创建一个observer
            let observer = AnonymousObserver<E>.init(eventBlock)
            
            //这里的subscribe根据self的具体类型去执行内部重写的方法
            //eg: Just.subscribe
            let disposable0 = self.asObservable().subscribe(observer)
            
            //将disposable和disposable0联系起来
            return Disposables.create(disposable0, disposable)
    }
}
