//
//  ACBViewController.swift
//  ACBRadialCollectionView
//
//  Created by Akhil on 5/21/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

class ACBViewController: UIViewController {

    let reuseIdentifier1 = "cell1"
    let reuseIdentifier2 = "cell2"
    let reuseIdentifier3 = "cell3"
    
    fileprivate var datasourceArray1: [String] = []
    fileprivate var datasourceArray2: [String] = []
    fileprivate var datasourceArray3: [String] = []
    
    fileprivate var itemRadius: CGFloat = 50
    fileprivate var arcRadius: CGFloat = 100
    fileprivate var center = CGPoint(x: 50, y: 100)
    fileprivate var startAngle = CGFloat(0)
    fileprivate var endAngle = CGFloat.pi / 2
    fileprivate var rotateCells = true
    
    @IBOutlet weak var collectionView1: UICollectionView?
    @IBOutlet weak var collectionView2: UICollectionView?
    @IBOutlet weak var collectionView3: UICollectionView?
    
    @IBOutlet weak var rotateFirstCVSwitch: UISwitch?
    @IBOutlet weak var rotateSecondCVSwitch: UISwitch?
    @IBOutlet weak var rotateThirdCVSwitch: UISwitch?
    
    @IBOutlet weak var changeAngleSegmentedControl: UISegmentedControl?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...1000 {
            datasourceArray1.append(String(i))
        }
        datasourceArray2 = datasourceArray1
        datasourceArray3 = datasourceArray1
        
        setupCollectionView1()
        setupCollectionView2()
        setupCollectionView3()
        
        updateSwitches()
    }
    
    
    fileprivate func setupCollectionView1() {
        let center = self.center
        let radius =  self.arcRadius
        let cellSize = CGSize(width: itemRadius, height: itemRadius)
        let startAngle =  self.startAngle
        let endAngle = self.endAngle
        let direction = ACBRadialCollectionViewScrollDirection.clockwise
        
        self.collectionView1?.enableRadialLayout(WithCenter: center, radius: radius, cellSize: cellSize, angularSpacing: 20.0, scrollDirection: direction, startAngle: startAngle, endAngle: endAngle)
        
        self.collectionView1?.applyRotationToCells = rotateCells
    }
    
    
    fileprivate func setupCollectionView2() {
        let center = self.center
        let radius =  self.arcRadius + CGFloat(20.0) + itemRadius
        let cellSize = CGSize(width: itemRadius, height: itemRadius)
        let startAngle =  self.startAngle
        let endAngle = self.endAngle
        let direction = ACBRadialCollectionViewScrollDirection.anticlockwise
        
        self.collectionView2?.enableRadialLayout(WithCenter: center, radius: radius, cellSize: cellSize, angularSpacing: 20.0, scrollDirection: direction, startAngle: startAngle, endAngle: endAngle)
        
        self.collectionView2?.applyRotationToCells = rotateCells
    }
    
    fileprivate func setupCollectionView3() {
        let center = self.center
        let radius =  self.arcRadius + CGFloat(2 * 20) + (2 * itemRadius)
        let cellSize = CGSize(width: itemRadius, height: itemRadius)
        let startAngle = self.startAngle
        let endAngle = self.endAngle
        let direction = ACBRadialCollectionViewScrollDirection.clockwise
        
        self.collectionView3?.enableRadialLayout(WithCenter: center, radius: radius, cellSize: cellSize, angularSpacing: 20.0, scrollDirection: direction, startAngle: startAngle, endAngle: endAngle)
        
        self.collectionView3?.applyRotationToCells = rotateCells
    }

    
    fileprivate func setupDefaultCenterRadius() {
        center = CGPoint(x: 50, y: 100)
        startAngle = CGFloat(0)
        endAngle = CGFloat.pi / 2
        rotateCells = true
    }
    
    
    fileprivate func setupSecondCenterRadius() {
        center = CGPoint(x: 90, y: 350)
        startAngle = 3 * CGFloat.pi / 2
        endAngle = 2 * CGFloat.pi
        rotateCells = false
    }
    
    fileprivate func setupThirdCenterRadius() {
        center = CGPoint(x: 330, y: 350)
        startAngle = CGFloat.pi
        endAngle = 3 * CGFloat.pi / 2
        rotateCells = true
    }
    
    
    fileprivate func setupFourthCenterRadius() {
        center = CGPoint(x: 330, y: 100)
        startAngle = CGFloat.pi / 2
        endAngle = CGFloat.pi
        rotateCells = false
    }
    
    
    fileprivate func setupFifthCenterRadius() {
        center = CGPoint(x: 135, y: 450)
        startAngle = 4 * CGFloat.pi / 3
        endAngle = 11 * CGFloat.pi / 6
        rotateCells = false
    }
    
    
    fileprivate func updateSwitches() {
        self.rotateFirstCVSwitch?.isOn = (self.collectionView1?.applyRotationToCells)!
        self.rotateSecondCVSwitch?.isOn = (self.collectionView2?.applyRotationToCells)!
        self.rotateThirdCVSwitch?.isOn = (self.collectionView3?.applyRotationToCells)!
    }
    
    @IBAction fileprivate func segmentChanged(_ sender: Any) {
        switch self.changeAngleSegmentedControl!.selectedSegmentIndex {
        case 0:
            self.setupDefaultCenterRadius()
            break
        case 1:
            self.setupSecondCenterRadius()
            break
        case 2:
            self.setupThirdCenterRadius()
            break
        case 3:
            self.setupFourthCenterRadius()
            break
        case 4:
            self.setupFifthCenterRadius()
            break
        default:
            self.setupDefaultCenterRadius()
        }
        
        self.setupCollectionView1()
        self.setupCollectionView2()
        self.setupCollectionView3()
        
        self.collectionView1?.reloadData()
        self.collectionView2?.reloadData()
        self.collectionView3?.reloadData()
        
        self.updateSwitches()
    }
    
    
    @IBAction fileprivate func firstSwitchChanged(_ sender: Any) {
        let isOn = self.rotateFirstCVSwitch!.isOn
        self.collectionView1?.applyRotationToCells = isOn
        self.collectionView1?.reloadData()
    }

    @IBAction fileprivate func secondSwitchChanged(_ sender: Any) {
        let isOn = self.rotateSecondCVSwitch!.isOn
        self.collectionView2?.applyRotationToCells = isOn
        self.collectionView2?.reloadData()
    }

    @IBAction fileprivate func thirdSwitchChanged(_ sender: Any) {
        let isOn = self.rotateThirdCVSwitch!.isOn
        self.collectionView3?.applyRotationToCells = isOn
        self.collectionView3?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension ACBViewController : UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! ACBCollectionViewCell
            cell.label?.text = datasourceArray1[indexPath.row]
            
            return cell
        } else if collectionView == self.collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! ACBCollectionViewCell
            cell.label?.text = datasourceArray2[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath) as! ACBCollectionViewCell
            cell.label?.text = datasourceArray3[indexPath.row]
            
            return cell
        }
        
        
    }
}
