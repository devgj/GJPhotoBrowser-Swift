//
//  GJPhotoBrowser.swift
//  GJPhotoBrowser-Swift
//
//  Created by GJ on 15/7/31.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit

protocol GJPhotoBrowserDataSource : NSObjectProtocol {
    func numberOfPhotosInPhotoBrowser(photoBrowser: GJPhotoBrowser) -> Int
    func photoBrowser(photoBrowser: GJPhotoBrowser, imageUrlAtIndex index: Int) -> String
}

class GJPhotoBrowser: UIViewController, UIScrollViewDelegate{
    // MARK: - Property
    var currentIndex = 0 /// current photo index
    weak var dataSource: GJPhotoBrowserDataSource?
    private lazy var numberOfPhotos = 0
    private lazy var reusePhotoViewsPool = NSMutableSet()
    private lazy var visiblePhotoViewsPool = NSMutableSet()
    private var scrollView: UIScrollView!
    
    private let margin: CGFloat = 10
    
    // MARK: - Public Method
    /**
    show with index 0
    */
    func show() {
        showWith(currentIndex: 0)
    }
    
    /**
    show with specify index, the index can't < 0
    */
    func showWith(#currentIndex: Int) {
        assert(currentIndex >= 0, "currentIndex不能小于0")
        self.currentIndex = currentIndex
        
        if let dataSource = self.dataSource {
            numberOfPhotos = dataSource.numberOfPhotosInPhotoBrowser(self)
        }
        
        if let window = UIApplication.sharedApplication().keyWindow {
            window.addSubview(self.view)
            window.rootViewController?.addChildViewController(self)
        }
        
        if self.currentIndex == 0 {
            showPhotoViews()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    // MARK: - Add Views
    private func setupScrollView() {
        scrollView = UIScrollView()
        var frame = self.view.bounds
        frame.origin.x -= margin
        frame.size.width += 2 * margin
        scrollView.frame = frame
        self.view.addSubview(scrollView)
        
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = CGSizeMake(CGFloat(numberOfPhotos) * CGRectGetWidth(frame), 0)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        showPhotoViews()
    }
    
    // MARK: - Private Method
    private func showPhotoViews() {
        if numberOfPhotos == 1 {
            showPhotoViewsAtIndex(0)
            return
        }
        
        
    
    }
    
    private func showPhotoViewsAtIndex(index: Int) {
        let photoView = dequeueReusablePhotoView()
        
        let scrollViewWidth = CGRectGetWidth(scrollView.bounds)
        
        let photoViewX = CGFloat(index) * scrollViewWidth + margin
        let photoViewWidth = scrollViewWidth - 2 * margin
        
        photoView.frame = CGRectMake(0, photoViewX, photoViewWidth, CGRectGetHeight(scrollView.frame))
        scrollView.addSubview(photoView)
        
        if let urlStr = dataSource?.photoBrowser(self, imageUrlAtIndex: index) {
            photoView.imageUrl = NSURL(string: urlStr)
        }
    }
    
    private func dequeueReusablePhotoView() -> GJPhotoView {
        var photoView: GJPhotoView!
        if let p = reusePhotoViewsPool.anyObject() as? GJPhotoView {
            photoView = p
            reusePhotoViewsPool.removeObject(p)
        } else {
            photoView = GJPhotoView()
        }
        return photoView
    }
    
    private func dismiss() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        dismiss()
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    

}
