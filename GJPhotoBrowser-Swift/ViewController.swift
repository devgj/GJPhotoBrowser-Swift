//
//  ViewController.swift
//  GJPhotoBrowser-Swift
//
//  Created by imooc_gj on 15/7/30.
//  Copyright (c) 2015年 devgj. All rights reserved.
// 1.init 2.add imageViews 3.add

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Property
    /// image urls
    lazy var urls: [String] = {
        let tempUrls = ["http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif", //gif
        "http://ww4.sinaimg.cn/wap360/67dd74e0gw1eue60fp791j20c60v7gnt.jpg",
        "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
        "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
        "http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
        "http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
        "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
        "http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
        "http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"]
        
        return tempUrls
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageViews()
    }
    
    /**
    add imageViews
    */
    func setupImageViews() {
        let width: CGFloat = 80
        let height: CGFloat = 80
        let margin: CGFloat = (CGRectGetWidth(self.view.bounds) - 3 * width) / 4
        
        let startX: CGFloat = 0.5 * (CGRectGetWidth(self.view.bounds) - 3 * width - 2 * margin)
        let startY: CGFloat = 0.5 * (CGRectGetHeight(self.view.bounds) - 3 * height - 2 * margin)
        
        // create imageViews
        for i in 0...8 {
            let imageView = UIImageView()
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            println("\(row) - \(col)")
            
            let x = startX + col * (width + margin)
            let y = startY + row * (height + margin)
            
            imageView.frame = CGRectMake(x, y, width, height)
            imageView.backgroundColor = UIColor.redColor()
            self.view.addSubview(imageView)
        }
    }

}

