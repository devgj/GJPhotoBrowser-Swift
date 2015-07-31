//
//  GJPhotoView.swift
//  GJPhotoBrowser-Swift
//
//  Created by imooc_gj on 15/7/31.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit

class GJPhotoView: UIScrollView {

    var imageUrl: NSURL? {
        didSet {
            println("imageUrl\(imageUrl)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purpleColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
