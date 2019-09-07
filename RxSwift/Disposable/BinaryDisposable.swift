//
//  BinaryDisposable.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

private final class BinaryDisposable : DisposeBase, Cancelable {
    
    private var _isDisposed = false
    
    // state
    private var _disposable1: Disposable?
    private var _disposable2: Disposable?
    
    /// - returns: Was resource disposed.
    var isDisposed: Bool {
        return _isDisposed
    }
    
    /// Constructs new binary disposable from two disposables.
    ///
    /// - parameter disposable1: First disposable
    /// - parameter disposable2: Second disposable
    init(_ disposable1: Disposable, _ disposable2: Disposable) {
        _disposable1 = disposable1
        _disposable2 = disposable2
        super.init()
    }
    
    /// Calls the disposal action if and only if the current instance hasn't been disposed yet.
    ///
    /// After invoking disposal action, disposal action will be dereferenced.
    func dispose() {
        if _isDisposed  == false {
            _isDisposed = true
            _disposable1?.dispose()
            _disposable2?.dispose()
            _disposable1 = nil
            _disposable2 = nil
        }
    }
    
    deinit {
        print("BinaryDisposable deinit ")
    }
}

extension Disposables {
    
    /// Creates a disposable with the given disposables.
    public static func create(_ disposable1: Disposable, _ disposable2: Disposable) -> Cancelable {
        return BinaryDisposable(disposable1, disposable2)
    }
    
}
