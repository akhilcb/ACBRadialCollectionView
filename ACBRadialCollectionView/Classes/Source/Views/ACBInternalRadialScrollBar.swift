//
//  ACBInternalRadialScrollBar.swift
//  RadialCollectionView
//
//  Created by Akhil on 1/1/17.
//  Copyright © 2017 Akhil. All rights reserved.
//

import UIKit

class ACBInternalRadialScrollBar: UIView {

    var scrollBarBackgroundColor = UIColor.lightGray
    var scrollBarThumbColor = UIColor.black
    var arcCenter : CGPoint = CGPoint.zero
    var radius : CGFloat = 0.0
    var scrollBarDirectionClockwise : Bool = true
    var scrollBarBackgroundWidth : CGFloat = 8.0
    var scrollBarThumbWidth: CGFloat = 6.0
    var thumbMinimumLengthAngle: CGFloat = .pi / 50
    
    let arcDrawDirectionClockwise : Bool = false
    
    fileprivate(set) var _scrollBarThumbStartAngle : CGFloat = .pi / 20
    fileprivate(set) var _scrollBarThumbLengthAngle : CGFloat = .pi / 20
    
    fileprivate(set) var _scrollBarThumbEndAngle : CGFloat {
        get {
            return _scrollBarThumbStartAngle + _scrollBarThumbLengthAngle
        }
        
        set(newValue) {
            _scrollBarThumbLengthAngle = newValue - _scrollBarThumbStartAngle
        }
    }
    
    fileprivate(set) var _startAngle : CGFloat = 0.0
    fileprivate(set) var _endAngle : CGFloat = .pi / 2
    
    var isScrollBarVisible : Bool {
        return !self.isHidden
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    init(frame: CGRect, arcCenter : CGPoint, radius : CGFloat) {
        super.init(frame: frame)
        self.arcCenter = arcCenter
        self.radius = radius
        self.setup()
    }

    fileprivate func setup () {
        self.backgroundColor = UIColor.clear
        self.radius = (self.radius != 0.0 ? self.radius : self.sliderRadius())
        self.isUserInteractionEnabled = false
        
        self.alpha = 0.5
    }
    
    func setScrollBarBackgroundAngle(startAngle : CGFloat, endAngle : CGFloat) -> Void {
        _startAngle = startAngle
        _endAngle = endAngle
        
        if _startAngle == 2 * .pi {
            _startAngle = 2 * .pi  - .pi / 180
        }
        
        if _endAngle == 2 * .pi {
            _endAngle = 2 * .pi  - .pi / 180
        }
        
        //reset scroll bar thumb angles and redraw
        if _scrollBarThumbStartAngle < _startAngle {
            _scrollBarThumbStartAngle = _startAngle
        }
        
        if _endAngle < _scrollBarThumbEndAngle {
            _scrollBarThumbEndAngle = _endAngle
        }
        //forces redraw
        setScrollBarThumbAngle(thumbStartAngle: _scrollBarThumbStartAngle, thumbLengthAngle: _scrollBarThumbLengthAngle)
    }
    
    
    func setScrollBarThumbAngle(thumbStartAngle : CGFloat, thumbLengthAngle : CGFloat) -> Void {
        
        guard thumbStartAngle >= _startAngle && _endAngle >= thumbStartAngle + thumbLengthAngle  else {
            return
        }
        
        _scrollBarThumbStartAngle = thumbStartAngle
        _scrollBarThumbLengthAngle = thumbLengthAngle
        
        if _scrollBarThumbStartAngle == 2 * .pi {
            _scrollBarThumbStartAngle = 2 * .pi  - .pi / 180
        }
        
        if _scrollBarThumbLengthAngle == 2 * .pi {
            _scrollBarThumbLengthAngle = 2 * .pi  - .pi / 180
        }
        
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(scrollBarBackgroundWidth)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        if radius == 0.0 {
            radius = sliderRadius()
        }
        
        context.setStrokeColor(scrollBarBackgroundColor.cgColor)
        drawBackground(withRadius: radius, inContext: context)
        
        context.setLineWidth(scrollBarThumbWidth)
        context.setStrokeColor(scrollBarThumbColor.cgColor)
        drawScrollBarThumb(withRadius: radius, inContext: context)
    }
    
    fileprivate func drawBackground(withRadius radius : CGFloat, inContext context : CGContext) {
        drawScrollBar(withRadius: radius, startAngle: _startAngle, endAngle: _endAngle, clockwise: arcDrawDirectionClockwise, inContext: context)
    }
    
    fileprivate func drawScrollBarThumb(withRadius radius : CGFloat, inContext context : CGContext) {
        let (scrollBarThumbStartAngle, scrollBarThumbEndAngle) = calculateThumbAngle()
        drawScrollBar(withRadius: radius, startAngle: scrollBarThumbStartAngle, endAngle: scrollBarThumbEndAngle, clockwise: arcDrawDirectionClockwise, inContext: context)
    }
    
    
    fileprivate func drawScrollBar(withRadius radius : CGFloat, startAngle: CGFloat, endAngle : CGFloat, clockwise : Bool, inContext context : CGContext) {
        UIGraphicsPushContext(context)
        context.beginPath()
        context.addArc(center: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        context.strokePath()
        UIGraphicsPopContext()
    }
    
    fileprivate func sliderRadius() -> CGFloat {
        var radius = min(self.bounds.size.width / 2, self.bounds.size.height / 2)
        radius -= max(scrollBarBackgroundWidth, scrollBarThumbWidth)
        return radius
    }
    
    fileprivate func calculateThumbAngle() -> (scrollBarThumbStartAngle : CGFloat, scrollBarThumbEndAngle : CGFloat) {
        var scrollBarThumbStartAngle = _scrollBarThumbStartAngle
        var scrollBarThumbEndAngle = _scrollBarThumbEndAngle
        
        if !scrollBarDirectionClockwise { //invert angle
            let diff = _scrollBarThumbStartAngle - _startAngle
            scrollBarThumbStartAngle = _endAngle - diff - _scrollBarThumbLengthAngle
            scrollBarThumbEndAngle = scrollBarThumbStartAngle + _scrollBarThumbLengthAngle
        }
        
        return (scrollBarThumbStartAngle, scrollBarThumbEndAngle)
    }
}
