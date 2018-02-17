# ACBRadialCollectionView <kbd><img src="/ACBRadialCollectionView/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png?raw=true" width="32"></kbd>

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ACBRadialCollectionView.svg)](https://img.shields.io/cocoapods/v/ACBRadialCollectionView.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/ACBRadialCollectionView.svg?style=flat)](https://github.com/akhilcb/ACBRadialCollectionView)
[![License](https://img.shields.io/cocoapods/l/ACBRadialCollectionView.svg?style=flat)](http://cocoapods.org/pods/ACBRadialCollectionView)


This is an extension on UICollectionView which automatically transforms collection view cells to a radial path with minimal code. 
This is written in Swift language. No need to subclass UICollectionView for this. CollectionView will also display an arc shaped scroll bar next to the cells which acts similar to the normal scroll bar. 

Using this approach, we can support multiple collectionviews on one screen as shown below(_Note: number of sections should be 1 for all collection views_). Each will have its own scrolling and scroll direction can also be changed for each of them separately.

## Demo
<kbd>
<div>
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCVgif1.gif?raw=true" width="260">
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCVgif2.gif?raw=true" width="260">
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCVgif3.gif?raw=true" width="260">
</div>
</kbd>

<div><br></div>

## Setup

Carthage or Cocoapods can be used to integrate this to a project. 

### Carthage

```
github "akhilcb/ACBRadialCollectionView" ~> 2.0

```

### Cocoapods

```
pod 'ACBRadialCollectionView'

```

This can be manually integrated to the project by following the code in __ACBViewController__. 

	1. Copy all files to your Xcode project. "UICollectionView+ACBRadialCollectionView" is the extension class file.
	2. Invoke the method "enableRadialLayout" on your UICollectionView with required input params.
  
For eg:-

	let center = CGPoint(x: 50, y: 100)
	let radius: CGFloat =  100
	let cellSize = CGSize(width: 50, height: 50)
	let startAngle =  CGFloat(0)
	let endAngle = CGFloat.pi / 2
	let direction = ACBRadialCollectionViewScrollDirection.clockwise
  
    self.collectionView.enableRadialLayout(WithCenter: center, radius: radius, cellSize: cellSize, angularSpacing: 20.0, scrollDirection: direction, startAngle: startAngle, endAngle: endAngle) //repeat this for other collectionviews too
    
You can also control whether the cells needs to be rotated to an angle(_Note: This works only if you have called enableRadialLayout before setting this, default value is true_).
 
    self.collectionView.applyRotationToCells = false

## Screenshots
<kbd>
<div>
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCollectionViewFirst.png?raw=true" width="260">
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCollectionViewSecond.png?raw=true" width="260">
<img src="/ACBRadialCollectionView/Screenshots/ACBRadialCollectionViewThird.png?raw=true" width="260">
</div>
</kbd>

## License

MIT License

Copyright (c) 2017, Akhil C Balan(https://github.com/akhilcb)

All rights reserved.
