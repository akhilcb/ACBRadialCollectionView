//
//  UICollectionView+ACBRadialCollectionView.swift
//  RadialCollectionView
//
//  Created by Akhil on 1/2/17.
//  Copyright © 2017 Akhil. All rights reserved.
//

import UIKit

private protocol ACBRadialCollectionViewProtocol {
    func enableRadialLayout(WithCenter center: CGPoint,
                            radius: CGFloat,
                            cellSize : CGSize,
                            angularSpacing : CGFloat,
                            scrollDirection : ACBRadialCollectionViewScrollDirection,
                            startAngle : CGFloat,
                            endAngle : CGFloat)
}


extension UICollectionView : ACBRadialCollectionViewProtocol {
    
    public var applyRotationToCells: Bool {
        get {
            if let circularLayout = self.collectionViewLayout as? ACBRadialCollectionViewLayout {
                
                return circularLayout.rotateCells
            }
            
            return false
        }
        
        set {
            if let circularLayout = self.collectionViewLayout as? ACBRadialCollectionViewLayout {
                
                circularLayout.rotateCells = newValue
            }
        }
    }
    
    
    public func enableRadialLayout(WithCenter center: CGPoint,
                            radius: CGFloat,
                            cellSize : CGSize,
                            angularSpacing : CGFloat,
                            scrollDirection : ACBRadialCollectionViewScrollDirection,
                            startAngle : CGFloat,
                            endAngle : CGFloat) {
        
        
        let circularLayout = ACBRadialCollectionViewLayout(center: center, radius: radius, cellSize: cellSize, angularSpacing: angularSpacing)
        circularLayout.setAngle(startAngle: startAngle, endAngle: endAngle, radialScrollDirection: scrollDirection)
        circularLayout.rotateCells = true
        
        self.collectionViewLayout = circularLayout
        self.backgroundColor = UIColor.clear

        let offset : CGFloat = 10.0
        let arcRadius = radius + cellSize.width / 2 + offset
        let clockwise = (scrollDirection == .clockwise)
        
        self.enableRadialScrollBar(WithScrollBarViewFrame: self.frame, arcCenter: center, radius: arcRadius, scrollDirectionClockwise : clockwise, startAngle : startAngle, endAngle : endAngle)
    }
    
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if let collectionlayout : ACBRadialCollectionViewLayout = self.collectionViewLayout as? ACBRadialCollectionViewLayout {
            let p1 = collectionlayout.center
            var p2 = point
            p2 = self.convert(p2, to: nil)
            
            let xDist = (p2.x - p1.x)
            let yDist = (p2.y - p1.y)
            
            let distance = sqrt((xDist * xDist) + (yDist * yDist))
            
            let outerRadius = (collectionlayout.radius + (collectionlayout.cellSize.width) + 5)
            let innerRadius = (collectionlayout.radius - (collectionlayout.cellSize.width) - 5)
            
            let angle = p1.angleToPoint(toPoint: p2)
            
            let distFlag : Bool = (distance <= outerRadius && distance >= innerRadius)
            let clockwise = true
            let angleFlag: Bool = angle.isWithInRadianAngleRange(start: collectionlayout.layoutStartAngle, end: collectionlayout.layoutEndAngle, clockwise: clockwise)
            
            return (distFlag && angleFlag)
        }
        
        return true
    }
    
}


fileprivate extension CGPoint {
    
    func angleToPoint(toPoint: CGPoint) -> CGFloat {
        
        let originX = toPoint.x - self.x
        let originY = toPoint.y - self.y
        var bearingRadians : CGFloat = CGFloat(atan2f(Float(originY), Float(originX)))
        while bearingRadians < 0 {
            bearingRadians += (2 * CGFloat.pi)
        }
        return bearingRadians
    }
}


fileprivate extension CGFloat {
    var degrees: CGFloat {
        return self * CGFloat(180.0 / CGFloat.pi)
    }
    
    func isWithInRadianAngleRange(start: CGFloat, end: CGFloat, clockwise: Bool) -> Bool {
        let startAngle = start.roundedAngle()
        let endAngle = end.roundedAngle()
        
        if (clockwise && (endAngle < startAngle)) {
            return (self.isWithInRadianAngleRange(start: startAngle,
                                                  end: CGFloat(2 * Double.pi),
                                                  clockwise: clockwise))
                || (self.isWithInRadianAngleRange(start: CGFloat(0),
                                                  end: endAngle,
                                                  clockwise: clockwise))
        } else if (!clockwise && (startAngle < endAngle)) {
            return (self.isWithInRadianAngleRange(start: startAngle,
                                                  end: CGFloat(0),
                                                  clockwise: clockwise))
                || (self.isWithInRadianAngleRange(start: CGFloat(2 * Double.pi),
                                                  end: endAngle,
                                                  clockwise: clockwise))
        }
        
        var range: ClosedRange<CGFloat>
        
        if clockwise {
            range = (startAngle...endAngle)
        } else {
            range = (endAngle...startAngle)
        }
        
        if range.contains(self.roundedAngle()) {
            return true
        }
        
        return false
    }
    
    func roundedAngle() -> CGFloat {
        var angle = self
        
        while angle < 0 {
            angle += CGFloat(2 * Double.pi)
        }
        
        while angle > CGFloat(2 * Double.pi) {
            angle -= CGFloat(2 * Double.pi)
        }
        
        return angle
    }

}

