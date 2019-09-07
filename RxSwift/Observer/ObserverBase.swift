//
//  ObserverBase.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

class ObserverBase<ElementType> : Disposable, ObserverType {
    typealias E = ElementType
    private var _isStopped = false
    
    func on(_ event: Event<E>) {
        switch event {
        case .next:
            if _isStopped == false {
                onCore(event)
            }
        case .error, .completed:
            if _isStopped == false {
                _isStopped = true
                onCore(event)
            }
        }
    }
    
    func onCore(_ event: Event<E>) {
        rxAbstractMethod()
    }
    
    func dispose() {
        _isStopped = true
    }
}


