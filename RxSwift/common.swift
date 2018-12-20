//
//  some.swift
//  TMRXSwift
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

#warning("swift4.2 - rxswift4.4.0")

/**
 rxswift 缩减版(学习Observable创建和订阅过程)
 1、Observable.just()
 2、observable.create...
 抽离出了两种创建observable的方式和subscribe过程，
 去掉了原有的各种保障机制（锁，原子操作，Scheduler控制等等),方便断点调试学习
 以便于了解其内部执行过程及原理

 **/

import Foundation

func rxAbstractMethod(file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    print("rxAbstractMethod:", file, line)
    fatalError(file: file, line: line)
}

func delayTime(time: TimeInterval, block: @escaping (() -> Void)) {
    let dispatchTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: block)
}
