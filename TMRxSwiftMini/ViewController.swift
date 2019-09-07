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
    
    @IBAction func createBag(_ sender: Any) {
        bag = DisposeBag()
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
    
    var bag = DisposeBag()
    /// 测试 Observable<Int>.create
    func test2() {
        let obs = Observable<Int>.create { (o) -> Disposable in
            o.onNext(1)
            delayTime(time: 1, block: {
                //o.onNext(2)
                o.onCompleted()
            })
            //o.onCompleted() // 如果在return之前就执行，下面的销毁1"则不会被执行到，
            // 因为当前观察序列在设置Disposablesz之前就completed了
            return Disposables.create {
                print("销毁1")
            }
            // return Disposables.create()
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

        disposeble.dispose()
        //        disposeble.disposed(by: bag)
        //        bag = DisposeBag()
        
        
        /**总结：disposeble一定要加入DisposeBag()管理，o.onCompleted(）也一定要在必要时调用，否者容易内部导致observer不销毁 */

    }
    
}

