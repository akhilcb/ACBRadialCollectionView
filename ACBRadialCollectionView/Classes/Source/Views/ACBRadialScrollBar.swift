//
//  ACBRadialScrollBar.swift
//  RadialCollectionView
//
//  Created by Akhil on 12/29/16.
//  Copyright © 2016 Akhil. All rights reserved.
//

import UIKit

class ACBRadialScrollBar: ACBInternalRadialScrollBar {

    private(set) var targetScrollView : UIScrollView?
    var minScrollBarLinearLength : CGFloat = 30.0
    private var fadingScrollBarTimer : Timer?
    var shouldHideScrollBar : Bool = true
    
    var contentHeight : CGFloat {
        if !scrollBarDirectionClockwise {
            return self.targetScrollView?.contentSize.width ?? 0.0
        }
        return self.targetScrollView?.contentSize.height ?? 0.0
    }
    
    var frameHeight : CGFloat {
        if !scrollBarDirectionClockwise {
            return self.targetScrollView?.frame.size.width ?? 0.0
        }
        return self.targetScrollView?.frame.size.height ?? 0.0
    }
    
    /// Calculate the current scroll value
    var currentScrollValue : CGFloat {
        guard (self.contentHeight != self.frameHeight) else {
            return 0
        }
        
        if !scrollBarDirectionClockwise {
            let contentOffsetX = self.targetScrollView?.contentOffset.x ?? 0
            return (contentOffsetX / (self.contentHeight - self.frameHeight))
        }
        
        let contentOffsetY = self.targetScrollView?.contentOffset.y ?? 0
        return (contentOffsetY / (self.contentHeight - self.frameHeight))
    }
    
    //calculated based on scroll view
    var handleLengthAngle : CGFloat {
        
        var angle = ((self.frameHeight / self.contentHeight) * (_endAngle - _startAngle))
        angle = ACBRadialScrollBar.snapToValue(angle, low: thumbMinimumLengthAngle, high: (_endAngle - _startAngle))
        return angle
    }
    
    convenience init(frame: CGRect, arcCenter : CGPoint, radius : CGFloat, targetScrollView : UIScrollView) {
        self.init(frame: frame, arcCenter : arcCenter, radius : radius)
        self.targetScrollView = targetScrollView
        self.setupTargetScrollView()
    }
    
    convenience init(frame: CGRect, arcCenter : CGPoint, radius : CGFloat, startAngle : CGFloat, endAngle : CGFloat, targetScrollView : UIScrollView) {
        self.init(frame: frame, arcCenter : arcCenter, radius : radius)
        self.targetScrollView = targetScrollView
        var tempEndAngle = endAngle
        if endAngle == 0.0 {
            tempEndAngle = 2 * .pi
        } else if startAngle != 0.0 && endAngle < startAngle {
            tempEndAngle = endAngle + 2 * .pi
        }
        
        self.setScrollBarBackgroundAngle(startAngle: startAngle, endAngle: tempEndAngle)
        self.setupTargetScrollView()
    }
    
    deinit {
        self.targetScrollView?.removeObserver(self, Key: .contentOffset)
        self.targetScrollView?.removeObserver(self, Key: .contentSize)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard (object as? UIScrollView) == self.targetScrollView else {
            return
        }
        
        let aKeyPath = UIScrollView.ObserverKeys.contentOffset.rawValue
        
        if keyPath == aKeyPath {
            viewDidScroll()
        } else {
            reloadScrollBar()
        }
    }
        
    fileprivate func setupTargetScrollView() {
        self.targetScrollView?.addObserver(self, Key: .contentOffset)
        self.targetScrollView?.addObserver(self, Key: .contentSize)
        
        let arcAngle = minScrollBarLinearLength / radius
        thumbMinimumLengthAngle = arcAngle
        
        self.reloadScrollBar()
    }
    
    fileprivate func reloadScrollBar() {
        
        guard (self.contentHeight >= self.frameHeight && self.targetScrollView?.isScrollEnabled == true) else {
            self.isHidden = true
            return
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let scrollValue = self.currentScrollValue
        var thumbLengthAngle = self.handleLengthAngle
        
        var thumbAngle = (scrollValue * (_endAngle - _startAngle)) + _startAngle - (scrollValue * thumbLengthAngle)
        calculateThumbAngleAndLengthAngleFor(thumbAngle: &thumbAngle, thumbLengthAngle: &thumbLengthAngle)

        //internally will call setNeedsDisplay
        self.setScrollBarThumbAngle(thumbStartAngle : thumbAngle, thumbLengthAngle : thumbLengthAngle)
        self.isHidden = (thumbLengthAngle == _endAngle - _startAngle)
        CATransaction.commit()
    }
    
    fileprivate func calculateThumbAngleAndLengthAngleFor(thumbAngle : inout CGFloat, thumbLengthAngle : inout CGFloat) {
        
        let diffFactor = ((_endAngle - _startAngle) / thumbLengthAngle)
        
        if thumbAngle < _startAngle {
            let diff = (_startAngle - thumbAngle) * diffFactor
            
            if thumbLengthAngle <= diff {
                thumbLengthAngle = .pi / 100
            } else {
                thumbLengthAngle = thumbLengthAngle - diff
            }
            thumbAngle = _startAngle
            
        }
        
        if thumbAngle + thumbLengthAngle > _endAngle {
            let diff = (thumbAngle + thumbLengthAngle - _endAngle) * diffFactor
            
            if thumbLengthAngle <= diff {
                thumbLengthAngle = .pi / 100
                thumbAngle = _endAngle - thumbLengthAngle
            } else {
                thumbLengthAngle = thumbLengthAngle - diff
                thumbAngle = thumbAngle + diff
            }
        }
        
        thumbAngle = ACBRadialScrollBar.snapToValue(thumbAngle, low: _startAngle, high: _endAngle - thumbLengthAngle)
    }
    
    fileprivate func viewDidScroll() {
        
        if shouldHideScrollBar == true {
            
            fadingScrollBarTimer?.invalidate()
            
            if self.alpha != 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0.5
                })
            }
        
            reloadScrollBar()
            
            fadingScrollBarTimer = Timer(timeInterval: 0.1, repeats: false, block: { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0.0
                })
            })
            RunLoop.main.add(fadingScrollBarTimer!, forMode: .common)
        } else {
            reloadScrollBar()
        }
    }
}


private extension ACBRadialScrollBar {
    
    static func snapToValue(_ value:CGFloat, low:CGFloat, high:CGFloat) -> CGFloat {
        if value > high {
            return high
        } else if low > value {
            return low
        } else {
            return value
        }
    }
    
    static func translateValueFromSourceIntervalToDestinationInterval(sourceValue : CGFloat,
                                                                      sourceIntervalMinimum : CGFloat,
                                                                      sourceIntervalMaximum : CGFloat,
                                                                      destinationIntervalMinimum : CGFloat,
                                                                      destinationIntervalMaximum : CGFloat) -> CGFloat {
        
        var a, b, destinationValue : CGFloat
    
        a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum)
        b = destinationIntervalMaximum - a * sourceIntervalMaximum
        destinationValue = a * sourceValue + b
        return destinationValue
    }
    
    static func angleBetweenThreePoints(centerPoint : CGPoint, p1 : CGPoint, p2 : CGPoint) -> CGFloat {
    
        let v1 = CGPoint(x: p1.x - centerPoint.x, y: p1.y - centerPoint.y)
        let v2 = CGPoint(x: p2.x - centerPoint.x, y: p2.y - centerPoint.y)
    
        let angle : CGFloat = atan2(v2.x * v1.y - v1.x * v2.y, v1.x * v2.x + v1.y * v2.y)
        return angle
    }
}


protocol ACBKeycodable {
    associatedtype ObserverKeys : RawRepresentable
}


extension UIScrollView : ACBKeycodable {
    
    var KVOOptions : NSKeyValueObservingOptions {
        return NSKeyValueObservingOptions([.new, .old, .prior])
    }
    
    enum ObserverKeys : String {
        case contentOffset
        case contentSize
    }
    
    func addObserver(_ observer: NSObject, Key key: ObserverKeys) {
        self.addObserver(observer, forKeyPath: key.rawValue , options: KVOOptions, context: nil)
    }
    
    func removeObserver(_ observer: NSObject, Key key: ObserverKeys) {
        self.removeObserver(observer, forKeyPath: key.rawValue, context: nil)
    }
}
