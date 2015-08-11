//
//  GJPhotoView.swift
//  GJPhotoBrowser-Swift
//
//  Created by GJ on 15/7/31.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

@objc protocol GJPhotoViewDelegate: NSObjectProtocol {
    optional func photoViewDidSingleTap(photoView: GJPhotoView) -> ()
}

class GJPhotoView: UIScrollView, UIScrollViewDelegate {
    // MARK: - Types
    struct photoViewConst {
        static let animationDuration = 0.25
        static let loadingViewWH = 50
    }
    
    // MARK: - Property
    weak var photoViewDelegate: GJPhotoViewDelegate?
    var fromImageView: UIImageView?
    var url: NSURL?
    weak var photoBrowserView: UIView?
    
    private var loadingView: GJProgressView
    private var imageView: UIImageView
    private var doubleTap = false
    
    //MARK: - Public Method
    func setImageWithURL(url: NSURL, fromImageView: UIImageView) {
        self.fromImageView = fromImageView
        self.url = url
    }
    
    func showImage(#animated: Bool) {
        loadingView.hidden = true
        if !animated {
           beginDownload()
        } else {
            imageView.image = fromImageView?.image
            imageView.frame = fromImageView!.convertRect(fromImageView!.bounds, toView: nil)
            
            let fittedSize = calculateFittedSize()
            UIView.animateWithDuration(photoViewConst.animationDuration, animations: { () -> Void in
                if fittedSize?.height <= CGRectGetHeight(self.bounds) {
                    self.imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
                    self.imageView.bounds = CGRectMake(0, 0, fittedSize!.width, fittedSize!.height)
                } else {
                    self.imageView.frame = CGRectMake(0, 0, fittedSize!.width, fittedSize!.height)
                }
                self.backgroundColor = UIColor.blackColor()
                
                }, completion: { (finished: Bool) -> Void in
                    
                self.photoBrowserView?.backgroundColor = UIColor.blackColor()
                self.beginDownload()
            })
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // imageView
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        // loadingView
        loadingView = GJProgressView()
        loadingView.hidden = true
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 2.0
        self.delegate = self
        
        self.addSubview(imageView)
        self.addSubview(loadingView)
        
        setupGesture()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        let photoViewSize = self.bounds.size;
        loadingView.center = CGPointMake(photoViewSize.width * 0.5 , photoViewSize.height * 0.5)
        loadingView.bounds = CGRect(x: 0, y: 0, width: photoViewConst.loadingViewWH, height: photoViewConst.loadingViewWH)
    }
    
    //MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // keep center when zoom
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.bounds.size
        
        let centerX = scrollViewSize.width > contentSize.width ? scrollViewSize.width * 0.5 : contentSize.width * 0.5
        let centerY = scrollViewSize.height > contentSize.height ? scrollViewSize.height * 0.5 : contentSize.height * 0.5
        
        imageView.center = CGPointMake(centerX, centerY)
    }
    
    //MARK: - Private Method
    private func setupGesture() {
        let doubleTapGes = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTapGes.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGes)
        
        let singleTapGes = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap"))
        self.addGestureRecognizer(singleTapGes)
    }
    
    private func beginDownload() {
        let exists = SDWebImageManager.sharedManager().cachedImageExistsForURL(url!)
        if !exists {
            loadingView.hidden = false
            loadingView.progress = 0.1
        }
        
        imageView.sd_setImageWithURL(url!, placeholderImage: fromImageView?.image, options: SDWebImageOptions.allZeros, progress: { [weak self] (receivedSize: Int, totalSize: Int) -> Void in
                let progress = Double(receivedSize) / Double(totalSize)
                self?.loadingView.progress = progress
            }) { [weak self] (image: UIImage!, error: NSError!,  cacheType: SDImageCacheType, url: NSURL!) -> Void in
                self?.downloadCompletionWithImage(image)
                self?.loadingView.hidden = true
        }
    }
    
    private func downloadCompletionWithImage(image: UIImage?) {
        if let aImage = image {
//            println("download success")
        } else {
//            println("download failure")
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
            if self.doubleTap { return }
            self.photoBrowserView?.backgroundColor = UIColor.clearColor()
            let frame = self.fromImageView!.convertRect(self.fromImageView!.bounds, toView: self)
            UIView.animateWithDuration(photoViewConst.animationDuration, animations: { () -> Void in
                self.imageView.frame = frame
                self.backgroundColor = UIColor.clearColor()
                
                }, completion: { (finished: Bool) -> Void in
                    
                if let delegate = self.photoViewDelegate {
                    if delegate.respondsToSelector(Selector("photoViewDidSingleTap:")) {
                        delegate.photoViewDidSingleTap!(self)
                    }
                }
            })
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
