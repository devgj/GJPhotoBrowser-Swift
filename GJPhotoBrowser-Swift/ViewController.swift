//
//  ViewController.swift
//  GJPhotoBrowser-Swift
//
//  Created by GJ on 15/7/30.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, GJPhotoBrowserDataSource {
    
    
    //MARK: - Property
    
    @IBOutlet weak var bgView: UIView!
    private lazy var urls: [String] = {
        return [
            "http://ww3.sinaimg.cn/wap360/006bUn4ljw1euwusbp673j30k00qoq7d.jpg",
            "http://ww1.sinaimg.cn/or360/a716fd45jw1eux8uc9k9gg208c08c1ky.jpg",
            "http://ww3.sinaimg.cn/wap360/67dd74e0gw1euxt4ok84xj20c84eanh4.jpg",
            "http://ww1.sinaimg.cn/wap360/006bUn4ljw1euwusav8n8j30dw099abb.jpg",
            "http://ww3.sinaimg.cn/wap360/006bUn4ljw1euwus9mkmfj30fa0a6751.jpg",
            "http://ww2.sinaimg.cn/wap360/006bUn4ljw1euwus8h8ubj30go0fdabh.jpg",
            "http://ww2.sinaimg.cn/wap360/006bUn4ljw1euwus84thpj30dw0dw76q.jpg",
            "http://ww3.sinaimg.cn/wap360/006bUn4ljw1euwus794ioj30dw0980to.jpg",
            "http://ww1.sinaimg.cn/wap360/006bUn4ljw1euwus6ooq6j30dw099aax.jpg"]
    }()
    
    private lazy var imageViews = [UIImageView]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageViews()
    }
    
    func setupImageViews() {
        let width: CGFloat = 80
        let height: CGFloat = 80
        let margin: CGFloat = (CGRectGetWidth(self.bgView.bounds) - 3 * width) / 4
        
        let startX: CGFloat = 0.5 * (CGRectGetWidth(self.bgView.bounds) - 3 * width - 2 * margin)
        let startY: CGFloat = 0.5 * (CGRectGetHeight(self.bgView.bounds) - 3 * height - 2 * margin)
        
        // create imageViews
        for i in 0..<urls.count {
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
            if let url = NSURL(string: self.urls[i]) {
                imageView.sd_setImageWithURL(url, completed: { [weak imageView] (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, url: NSURL!) -> Void in
                    imageView?.userInteractionEnabled = error == nil
                })
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
//        let srcImageView = imageViews[index]
        let urlStr = getBigImageUrlStrAtIndex(index)
        photoView.setImageWithURL(NSURL(string: urlStr)!, fromImageView: imageViews[index])
        return photoView
    }
    
    // MARK: - Other
    
    func getBigImageUrlStrAtIndex(index: Int) -> String {
        var bigImage_urlStr: String!
        let thumbnail_urlStr = urls[index] as NSString
        if thumbnail_urlStr.containsString("or360") {
            bigImage_urlStr = thumbnail_urlStr.stringByReplacingOccurrencesOfString("or360", withString: "woriginal")
        } else {
            bigImage_urlStr = thumbnail_urlStr.stringByReplacingOccurrencesOfString("wap360", withString: "wap720")
        }
        return bigImage_urlStr
    }
    
    func tapImage(sender: UIGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        guard imageView.image != nil else {
            return
        }
        let photoBrowser = GJPhotoBrowser()
        photoBrowser.dataSource = self
        
        var index = 0
        if let view = sender.view {
            index = view.tag
        }
        photoBrowser.showWith(currentIndex: index)
    }
    
    @IBAction func onClickClearCacheButton() {
        SDImageCache.sharedImageCache().clearDisk()
        SDImageCache.sharedImageCache().clearMemory()
        for (index, imageView) in imageViews.enumerate() {
            imageView.sd_setImageWithURL(NSURL(string: urls[index]))
        }
    }
}

