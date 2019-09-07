//
//  Disposable.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import Foundation

public protocol Disposable {
    func dispose()
}

public protocol Cancelable : Disposable {
    /// Was resource disposed.
    var isDisposed: Bool { get }
}
