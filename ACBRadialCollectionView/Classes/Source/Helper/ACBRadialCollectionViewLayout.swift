//
//  ACBRadialCollectionViewLayout.swift
//  RadialCollectionView
//
//  Created by Akhil on 11/26/16.
//  Copyright © 2016 Akhil. All rights reserved.
//


import UIKit

public enum ACBRadialCollectionViewScrollDirection : Int {
    case clockwise
    case anticlockwise
}


class ACBRadialCollectionViewLayout: UICollectionViewLayout {
    
    var center: CGPoint = CGPoint.zero
    var radius: CGFloat = 0.0
    var rotateCells: Bool = false
    
    fileprivate(set) var cellSize : CGSize = CGSize.zero
    fileprivate(set) var radialScrollDirection : ACBRadialCollectionViewScrollDirection = .anticlockwise
    
    fileprivate var angularSpacing: CGFloat = 0.0
    fileprivate var angleOfEachCell: CGFloat = 0.0
    fileprivate var angleForSpacing: CGFloat = 0.0
    fileprivate var totalCircleLength: CGFloat = 0.0
    fileprivate var numberOfCells: Int = 0
    fileprivate var maxNoOfCellsInCircle: CGFloat = 0.0
    
    fileprivate var startAnglePrivate: CGFloat = 0.0
    fileprivate var endAnglePrivate: CGFloat = 0.0

    fileprivate(set) var layoutStartAngle: CGFloat = 0.0
    fileprivate(set) var layoutEndAngle: CGFloat = 0.0
    
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(center : CGPoint, radius : CGFloat, cellSize : CGSize, angularSpacing : CGFloat) {
        self.init()
        self.center = center
        self.radius = radius
        self.cellSize = cellSize
        self.angularSpacing = angularSpacing
    }
    
    
    func setAngle(startAngle : CGFloat, endAngle : CGFloat, radialScrollDirection : ACBRadialCollectionViewScrollDirection) -> Void {
        self.radialScrollDirection = radialScrollDirection
        self.layoutStartAngle = startAngle
        self.layoutEndAngle = endAngle
        
        var tempEndAngle = endAngle
        
        if endAngle == 0.0 {
            tempEndAngle = 2 * .pi
        } else if startAngle != 0.0 && endAngle < startAngle {
            tempEndAngle = endAngle + 2 * .pi
        }
        
        if radialScrollDirection == .anticlockwise {//reverse start and end
            startAnglePrivate = tempEndAngle
            endAnglePrivate = startAngle
        } else {
            startAnglePrivate = startAngle * -1
            endAnglePrivate = tempEndAngle * -1
        }
        
        if startAnglePrivate == 2 * .pi {
            startAnglePrivate = 2 * .pi  - .pi / 180
        }
        
        if endAnglePrivate == 2 * .pi {
            endAnglePrivate = 2 * .pi  - .pi / 180
        }
    }
    
    override func prepare() {
        super.prepare()
        numberOfCells = (self.collectionView?.numberOfItems(inSection: 0))!
        totalCircleLength =  abs(startAnglePrivate - endAnglePrivate) * radius
        maxNoOfCellsInCircle =  totalCircleLength / (max(cellSize.width, cellSize.height) + angularSpacing / 2)
        angleOfEachCell = abs(startAnglePrivate - endAnglePrivate) / maxNoOfCellsInCircle
    }
    
    
    override var collectionViewContentSize: CGSize {
        
        let visibleAngle = abs(startAnglePrivate - endAnglePrivate)
        let remainingCellsCount = numberOfCells > Int(ceil(maxNoOfCellsInCircle)) ? numberOfCells - Int(ceil(maxNoOfCellsInCircle)) : 0
        let scrollableContentWidth = (CGFloat(remainingCellsCount) + 0.5) * angleOfEachCell * radius / (2 * .pi / visibleAngle)
        let height = radius + max(cellSize.width, cellSize.height / 2)

        if radialScrollDirection == ACBRadialCollectionViewScrollDirection.clockwise {
            return CGSize(width: height, height: scrollableContentWidth + (self.collectionView?.bounds.size.height)!)
        }
        
        return CGSize(width: scrollableContentWidth + (self.collectionView?.bounds.size.width)!, height: height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if (radialScrollDirection == .clockwise) {
            return layoutAttributesForClockwiseScrollForItem(at: indexPath)
        }
        
        return layoutAttributesForAntiClockwiseScrollForItem(at: indexPath)
    }
    
    fileprivate func layoutAttributesForAntiClockwiseScrollForItem(at indexPath : IndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var offset : CGFloat = (self.collectionView?.contentOffset.x)!
        offset = (offset != 0) ? offset : 1
        
        let offsetInAngle = offset / totalCircleLength
        let angle = 2 * .pi * offsetInAngle
        attributes.size = cellSize
    
        let deltaX = (radius * cos(CGFloat(indexPath.item) * angleOfEachCell - angle + angleOfEachCell / 2 - startAnglePrivate))
        let deltaY = (radius * sin(CGFloat(indexPath.item) * angleOfEachCell - angle + angleOfEachCell/2 - startAnglePrivate))
        let x = center.x + offset + deltaX
        let y = center.y - deltaY

        let cellAngle = CGFloat(indexPath.item) * angleOfEachCell + angleOfEachCell / 2 - angle
        
        if cellAngle >= -angleOfEachCell/2 && cellAngle <= (abs(startAnglePrivate - endAnglePrivate) + angleOfEachCell / 2) {
            attributes.alpha = 1
        } else {
            attributes.alpha = 0
        }
        
        attributes.center = CGPoint(x: x, y: y)
        attributes.zIndex = numberOfCells - indexPath.item
        
        if rotateCells {
            attributes.transform = CGAffineTransform(rotationAngle: -1 * cellAngle )
        }
        
        return attributes
    }
    
    fileprivate func layoutAttributesForClockwiseScrollForItem(at indexPath : IndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var offset: CGFloat = (self.collectionView?.contentOffset.y)!
        offset = (offset != 0) ? offset : 1
        
        let offsetInAngle = offset / totalCircleLength
        let angle = 2 * .pi * offsetInAngle
        attributes.size = cellSize
        
        let deltaX = (radius * cos(CGFloat(indexPath.item) * angleOfEachCell - angle + angleOfEachCell / 2 - startAnglePrivate))
        let deltaY = (radius * sin(CGFloat(indexPath.item) * angleOfEachCell - angle + angleOfEachCell / 2 - startAnglePrivate))
        let x = center.x + deltaX
        let y = center.y + offset + deltaY
        
        let cellAngle = CGFloat(indexPath.item) * angleOfEachCell + angleOfEachCell / 2 - angle
        
        if cellAngle >= -angleOfEachCell/2 && cellAngle <= (abs(startAnglePrivate - endAnglePrivate) + angleOfEachCell / 2) {
            attributes.alpha = 1
        } else {
            attributes.alpha = 0
        }
        
        attributes.center = CGPoint(x: x, y: y)
        attributes.zIndex = numberOfCells - indexPath.item
        
        if rotateCells {
            attributes.transform = CGAffineTransform(rotationAngle: cellAngle - (.pi / 2))
        }
        
        return attributes
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for i in 0..<numberOfCells {
            let indexPath = IndexPath(item: i, section: 0)
            let cellAttributes = layoutAttributesForItem(at: indexPath)!
            if cellAttributes.alpha != 0 {
                attributes.append(cellAttributes)
            }
        }
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.center = CGPoint(x: center.x + (self.collectionView?.contentOffset.x)!, y: center.y + (self.collectionView?.contentOffset.y)!)
        attributes?.alpha = 0.2
        attributes?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attributes?.center = CGPoint(x: center.x + (self.collectionView?.contentOffset.x)!, y: center.y + (self.collectionView?.contentOffset.y)!)
        attributes?.alpha = 0.2
        attributes?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return attributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
