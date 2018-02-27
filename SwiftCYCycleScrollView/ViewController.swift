//
//  ViewController.swift
//  SwiftCYCycleScrollView
//
//  Created by cyan on 2018/2/27.
//  Copyright © 2018年 cyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CycleScrollViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //使用网络图片 
        var cycleScrollView = CYCycleScrollView()
        cycleScrollView = CYCycleScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        view.addSubview(cycleScrollView)
        cycleScrollView.imageNames = [
        "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
        "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
        "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        ]
        
        //使用本地图片
        var cycleScrollView2 = CYCycleScrollView()
        cycleScrollView2 = CYCycleScrollView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 300))
        view.addSubview(cycleScrollView)
         cycleScrollView2.imageNames = ["h1.jpg","h2.jpg","h3.jpg"]

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

