//
//  ObservableType.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

public protocol ObservableType: ObservableConvertibleType {
    
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E
}


public protocol ObservableConvertibleType {
    /// Type of elements in sequence.
    associatedtype E
    
    /// Converts `self` to `Observable` sequence.
    ///
    /// - returns: Observable sequence that represents `self`.
    func asObservable() -> Observable<E>
}
