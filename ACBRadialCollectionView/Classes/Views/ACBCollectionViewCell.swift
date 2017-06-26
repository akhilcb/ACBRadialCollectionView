//
//  ACBCollectionViewCell.swift
//  RadialCollectionView
//
//  Created by Akhil on 11/26/16.
//  Copyright © 2016 Akhil. All rights reserved.
//

import UIKit

class ACBCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeItCircle()
    }
    
    func makeItCircle() {
        self.label.layer.masksToBounds = true
        self.label.layer.cornerRadius  = CGFloat(round(self.label.frame.size.width / 2.0))
    }
}
