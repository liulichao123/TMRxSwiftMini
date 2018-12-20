//
//  ViewController.swift
//  TMRxSwiftMini
//
//  Created by 天明 on 2018/12/20.
//  Copyright © 2018 天明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //test1()
        test2()
    }
    
    /// 测试 Observable<Int>.just(...)
    func test1() {
        let obs = Observable<Int>.just(1)
        let disposeble = obs.subscribe(onNext: { (value) in
            print("onNext", value)
        }, onError: { (e) in
            print("onError", e)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
        disposeble.dispose()
        //disposeble.disposed(by: bag)
    }

    
    @IBAction func createBag(_ sender: Any) {
        bag = DisposeBag()
    }
    var bag = DisposeBag()
    /// 测试 Observable<Int>.create
    func test2() {
        let obs = Observable<Int>.create { (o) -> Disposable in
            o.onNext(1)
            delayTime(time: 1, block: {
                o.onNext(2)
                o.onCompleted()
            })
            //o.onCompleted()
            return Disposables.create()
        }
        let disposeble = obs.subscribe(onNext: { (value) in
            print("onNext", value)
        }, onError: { (e) in
            print("onError", e)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
        disposeble.disposed(by: bag)
    }
    
}

