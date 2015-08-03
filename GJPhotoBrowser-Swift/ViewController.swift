//
//  ViewController.swift
//  GJPhotoBrowser-Swift
//
//  Created by GJ on 15/7/30.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, GJPhotoBrowserDataSource {
    
    @IBOutlet weak var bgView: UIView!
    //MARK: - Property
    /// image urls
    private lazy var urls: [String] = {
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
    
    private lazy var imageViews = [UIImageView]()
    
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
        let margin: CGFloat = (CGRectGetWidth(self.bgView.bounds) - 3 * width) / 4
        
        let startX: CGFloat = 0.5 * (CGRectGetWidth(self.bgView.bounds) - 3 * width - 2 * margin)
        let startY: CGFloat = 0.5 * (CGRectGetHeight(self.bgView.bounds) - 3 * height - 2 * margin)
        
        // create imageViews
        for i in 0...8 {
            let imageView = UIImageView()
            
            // frame
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            let x = startX + col * (width + margin)
            let y = startY + row * (height + margin)
            imageView.frame = CGRectMake(x, y, width, height)
            
            // property
            imageView.backgroundColor = UIColor.redColor()
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = i
            imageView.userInteractionEnabled = true
            if let url = NSURL(string: self.urls[i]) {
                imageView.kf_setImageWithURL(url)
            }
            
            self.bgView.addSubview(imageView)
            
            // gesture
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapImage:"))
            imageView.addGestureRecognizer(tap)
            
            imageViews.append(imageView)
        }
    }
    
    // MARK: - GJPhotoBrowserDataSource
    func numberOfPhotosInPhotoBrowser(photoBrowser: GJPhotoBrowser) -> Int {
        return urls.count
    }
    
    func photoBrowser(photoBrowser: GJPhotoBrowser, viewForIndex index: Int) -> GJPhotoView {
        let photoView = photoBrowser.dequeueReusablePhotoView()
        let srcImageView = imageViews[index]
        let urlStr = getBigImageUrlStrAtIndex(index)
        photoView.setImageWithURL(NSURL(string: urlStr)!, fromImageView: imageViews[index])
        return photoView
    }
    
    func getBigImageUrlStrAtIndex(index: Int) -> String {
        var bigImage_urlStr: String!
        let thumbnail_urlStr = urls[index] as NSString
        if thumbnail_urlStr.containsString("thumbnail") {
            bigImage_urlStr = thumbnail_urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        } else {
            bigImage_urlStr = thumbnail_urlStr.stringByReplacingOccurrencesOfString("wap360", withString: "wap720")
        }
        return bigImage_urlStr
    }
    
    /**
    *  tap image
    */
    func tapImage(sender: UIGestureRecognizer) {
        let photoBrowser = GJPhotoBrowser()
        photoBrowser.dataSource = self
        
        var index = 0
        if let view = sender.view {
            index = view.tag
        }
        photoBrowser.showWith(currentIndex: index)
    }
    
    
}

