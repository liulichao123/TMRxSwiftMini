//
//  DisposeBag.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

extension Disposable {
    /// Adds `self` to `bag`
    ///
    /// - parameter bag: `DisposeBag` to add `self` to.
    public func disposed(by bag: DisposeBag) {
        bag.insert(self)
    }
}

public final class DisposeBag {

    fileprivate var _disposables = [Disposable]()
    fileprivate var _isDisposed = false
    
    /// Constructs new empty dispose bag.
    init() { }
    
    /// Adds `disposable` to be disposed when dispose bag is being deinited.
    ///
    /// - parameter disposable: Disposable to add.
    public func insert(_ disposable: Disposable) {
        _insert(disposable)?.dispose()
    }
    
    private func _insert(_ disposable: Disposable) -> Disposable? {
        if _isDisposed {
            return disposable
        }
        
        _disposables.append(disposable)
        
        return nil
    }
    
    /// This is internal on purpose, take a look at `CompositeDisposable` instead.
    private func dispose() {
        let oldDisposables = _dispose()
        
        for disposable in oldDisposables {
            disposable.dispose()
        }
    }
    
    private func _dispose() -> [Disposable] {
        let disposables = _disposables
        
        _disposables.removeAll(keepingCapacity: false)
        _isDisposed = true
        
        return disposables
    }
    
    deinit {
        dispose()
    }
}

extension DisposeBag {
    
    /// Convenience init allows a list of disposables to be gathered for disposal.
    public convenience init(disposing disposables: Disposable...) {
        self.init()
        _disposables += disposables
    }
    
    /// Convenience init allows an array of disposables to be gathered for disposal.
    public convenience init(disposing disposables: [Disposable]) {
        self.init()
        _disposables += disposables
    }
    
    /// Convenience function allows a list of disposables to be gathered for disposal.
    public func insert(_ disposables: Disposable...) {
        insert(disposables)
    }
    
    /// Convenience function allows an array of disposables to be gathered for disposal.
    public func insert(_ disposables: [Disposable]) {
        if _isDisposed {
            disposables.forEach { $0.dispose() }
        } else {
            _disposables += disposables
        }
    }
}
