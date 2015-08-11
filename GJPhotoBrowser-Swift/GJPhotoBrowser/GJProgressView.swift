//
//  GJProgressView.swift
//  GJPhotoBrowser-Swift
//
//  Created by imooc_gj on 15/8/11.
//  Copyright (c) 2015年 devgj. All rights reserved.
//

import UIKit

class GJProgressView: UIView {

    var progress: Double = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var mCenter = CGPointZero
    
    var mRadius: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.layer.masksToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if (mRadius == 0) {
            let w = rect.size.width;
            let h = rect.size.height;
            mCenter = CGPointMake(w * 0.5, h * 0.5);
            mRadius = min(w, h) * 0.5 - 8;
            self.layer.cornerRadius = min(w, h) * 0.5;
        }
        let ctx = UIGraphicsGetCurrentContext();
        
        let center = mCenter;
        let radius = mRadius;
        let startAngle = CGFloat(-M_PI_2);
        let endAngle = CGFloat(-M_PI_2 + progress * M_PI * 2);
        
        let blackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: CGFloat(M_PI * 2.0) + startAngle, clockwise: true)
        CGContextSetLineWidth(ctx, 5.0);
        UIColor.blackColor().set()
        CGContextAddPath(ctx, blackPath.CGPath);
        CGContextStrokePath(ctx);
        
        let whitePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        CGContextSetLineWidth(ctx, 5.0);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        UIColor.whiteColor().set()
        CGContextAddPath(ctx, whitePath.CGPath);
        CGContextStrokePath(ctx);
    }
}
