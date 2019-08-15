//
//  ViewController.swift
//  TKCrashLogModule
//
//  Created by zhuamaodeyu on 12/23/2018.
//  Copyright (c) 2018 zhuamaodeyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        installSubviews()
    }
}

extension ViewController {
    fileprivate func installSubviews() {
        let button1 = UIButton(type: .custom)
        button1.backgroundColor = UIColor.red
        button1.addTarget(self, action: #selector(buttonAcion1), for: .touchUpInside)
        button1.setTitle("NSException", for: .normal)
        button1.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 50)
        view.addSubview(button1)
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = UIColor.red
        button2.addTarget(self, action: #selector(buttonAcion2), for: .touchUpInside)
        button2.setTitle("Signal", for: .normal)
        button2.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 50)
        view.addSubview(button2)
    }
}

extension ViewController {
    @objc fileprivate func buttonAcion1() {
        let array = NSArray()
        debugPrint(array[1])
        
    }
    @objc fileprivate func buttonAcion2() {
        // 此处在 debug 模式无法处理，请在真机上运行处理  
        let string: String? = nil
        print("\(string!)")
    }
}

