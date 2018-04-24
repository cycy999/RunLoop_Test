//
//  ViewController.swift
//  RunLoop_Test
//
//  Created by 陈岩 on 2018/4/23.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //runloop()
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.performSelector(inBackground: #selector(runloop), with: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func runloop() {
        //当有其他主线程时，计时器方法会被暂时阻断，从而影响实际计时方法
        //let timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printString), userInfo: nil, repeats: true)
        
        //将之放到runloop后在主线程的操作不会影响计时器方法，从而保证计时器的正常工作
        DispatchQueue.global().async {
            //将下面方法放到此线程中则是在子线程中添加了 runloop 方法
        }
        //如果不放在子线程中，放在主线程中也可以，但是要放在指定的 runloop 的 mode 中，避免被复杂操作或者ui界面的刷新所干扰，下面的代码为放在主线程中的示例
        
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(self.printString), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        //RunLoop.current.run(mode: RunLoopMode.commonModes, before: Date(timeIntervalSinceNow: 5))
        
        //此方法不可与 RunLoop.current.run() 同用，否则以后面的为准，此方法会无效（不论两方法是否调换位置）
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 5))
        
        //run()一旦运行，上面的限时方法则无效，除非使用CFRunLoopRun()方法结束，否则会一直运行下去
        //RunLoop.current.run()
        
        print("end")//如果使用run(),则永远不会打印，如果使用限时方法，则时间到达后会打印出来
    }
    
    @objc func printString() {
        print(Date())
        //使用CFRunLoopStop(runLoopRef)来停止RunLoop的运行，对主线程的 default 的 mode 无效
        //CFRunLoopRun()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }

}

