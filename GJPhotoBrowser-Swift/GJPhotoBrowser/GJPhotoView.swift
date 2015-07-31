//
//  GJPhotoView.swift
//  GJPhotoBrowser-Swift
//
//  Created by GJ on 15/7/31.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol GJPhotoViewDelegate: NSObjectProtocol {
    optional func photoViewDidSingleTap(photoView: GJPhotoView) -> ()
}

class GJPhotoView: UIScrollView, UIScrollViewDelegate {
    // MARK: - Property
    var imageUrl: NSURL? {
        didSet {
            downloadImage()
        }
    }
    
    private var imageView: UIImageView
    private var doubleTap = false
    weak var photoViewDelegate: GJPhotoViewDelegate?

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.backgroundColor = UIColor.purpleColor()
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 2.0
        self.delegate = self
        
        setupGesture()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
    }
    
    //MARK: - Private Method
    private func setupGesture() {
        let doubleTapGes = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTapGes.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGes)
        
        let singleTapGes = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap"))
        self.addGestureRecognizer(singleTapGes)
    }
    
    private func downloadImage() {
        if let url = imageUrl {
            imageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize: Int64, totalSize: Int64) -> () in
                
            }, completionHandler: { [weak self] (image: UIImage?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) -> () in
                if let wself = self {
                    wself.downloadCompletionWithImage(image)
                }
            })
        }
    }
    
    private func downloadCompletionWithImage(image: UIImage?) {
        if let aImage = image {
            println("下载成功")
        } else {
            println("下载失败")
        }
        
        setupImageViewFrame()
    }
    
    private func setupImageViewFrame() {
        if imageView.image == nil { return }
        
        self.zoomScale = self.minimumZoomScale
        
        if let fitSize = calculateFittedSize() {
            if fitSize.height <= CGRectGetHeight(self.bounds) {
                imageView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5)
                imageView.bounds = CGRectMake(0, 0, fitSize.width, fitSize.height)
            } else {
                imageView.frame = CGRectMake(0, 0, fitSize.width, fitSize.height)
            }
            self.contentSize = imageView.bounds.size
        }
    }
    
    private func calculateFittedSize() -> CGSize? {
        if let image = imageView.image {
            let imageSize = image.size
            var fitSize = imageSize
            fitSize.width = CGRectGetWidth(self.bounds)
            fitSize.height = fitSize.width / imageSize.width * imageSize.height
            return fitSize
        }
        return nil
    }
    
    // MARK: - Event Response
    func handleSingleTap() {
        doubleTap = false
        let time: NSTimeInterval = 0.3
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            if self.doubleTap {
               return
            }
            
            if let delegate = self.photoViewDelegate {
                if delegate.respondsToSelector(Selector("photoViewDidSingleTap:")) {
                    delegate.photoViewDidSingleTap!(self)
                }
            }
        }
    }
    
    func handleDoubleTap(tap: UITapGestureRecognizer) {
        doubleTap = true
        if self.zoomScale == self.minimumZoomScale {
            let tapPoint = tap.locationInView(self)
            self.zoomToRect(CGRectMake(tapPoint.x, tapPoint.y, 1, 1), animated: true)
        } else {
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }
    }
    
}
