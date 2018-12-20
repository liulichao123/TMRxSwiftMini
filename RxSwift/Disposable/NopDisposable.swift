//
//  NopDisposable.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

struct NopDisposable : Disposable {
    
    static let noOp: Disposable = NopDisposable()
    
    init() { }
    
    /// Does nothing.
    public func dispose() { }
}
