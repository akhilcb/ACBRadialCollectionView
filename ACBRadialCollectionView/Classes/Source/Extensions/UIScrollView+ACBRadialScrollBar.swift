//
//  UIScrollView+ACBRadialScrollBar.swift
//  RadialCollectionView
//
//  Created by Akhil on 1/2/17.
//  Copyright © 2017 Akhil. All rights reserved.
//

import UIKit

private protocol ACBRadialScrollBarProtocol {
    func enableRadialScrollBar(WithScrollBarViewFrame frame: CGRect,
                               arcCenter : CGPoint,
                               radius : CGFloat,
                               scrollDirectionClockwise : Bool,
                               startAngle : CGFloat,
                               endAngle : CGFloat)
}


extension UIScrollView : ACBRadialScrollBarProtocol {
    
    //scrollview must be added to superview before invoking enableRadialScrollBar()
    //clockwise is true for vertical scrolling and false for horizonal scrolling
    public func enableRadialScrollBar(WithScrollBarViewFrame frame: CGRect,
                               arcCenter: CGPoint,
                               radius: CGFloat,
                               scrollDirectionClockwise: Bool,
                               startAngle: CGFloat = 0,
                               endAngle: CGFloat = .pi / 2) {
        
        if let scrollSuperView = self.superview {
            
            self.scrollBar?.removeFromSuperview()
            self.scrollBar = ACBRadialScrollBar(frame : frame,
                                                arcCenter : arcCenter,
                                                radius: radius,
                                                startAngle : startAngle,
                                                endAngle : endAngle,
                                                targetScrollView : self)
            
            if let scrollBar = self.scrollBar {
                scrollSuperView.addSubview(scrollBar)
                scrollBar.layer.zPosition = 1000
                self.showsVerticalScrollIndicator = false
                self.showsHorizontalScrollIndicator = false
                self.isScrollEnabled = true
                scrollBar.scrollBarDirectionClockwise = scrollDirectionClockwise
            }
        } else {
            print("ScrollView should be added to superView before invoking enableRadialScrollBar().")
        }
    }
    
    private struct AssociatedKeys {
        static var scrollBar = "scrollBar"
    }
    
    var scrollBar : ACBRadialScrollBar? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.scrollBar) as? ACBRadialScrollBar
        }
        
        set(newValue) {
            objc_setAssociatedObject(self,&AssociatedKeys.scrollBar, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
