# TMRxSwiftMini
rxswift 缩减版(学习Observable创建和订阅过程)<br>

 1、Observable.just()<br>
 2、observable.create...<br>
 抽离出了两种创建observable的方式和subscribe过程，<br>
 去掉了原有的各种保障机制（锁，原子操作，Scheduler控制等等),方便断点调试学习<br>
 以便于了解其内部执行过程及原理<br>
