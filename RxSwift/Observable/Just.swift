//
//  Just.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

extension ObservableType {

    public static func just(_ element: E) -> Observable<E> {
        return Just(element: element)
    }

}

final fileprivate class Just<Element> : Producer<Element> {
    private let _element: Element
    
    init(element: Element) {
        _element = element
    }
    
    // Just.subscribe
    override func subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        observer.on(.next(_element))//将存储的事件发送出去
        observer.on(.completed)//只有1个事件，发完之后就会发送完成事件
        return Disposables.create()
    }
}
