//
//  ColorPickerParentView.swift
//  Bones
//
//  Created by Student on 5/4/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class ColorPickerParentView: UIView {

    required init?(coder aDecoder: NSCoder) {
        // call initializer and setup gestures
        super.init(coder: aDecoder)
        setupGestures()
    }
    
    // private setup function
    private func setupGestures()
    {
        // loop through all subviews
        for v in self.subviews {
            
            // only select boxes that aren't the currentColor box
            if v.tag == 0 {
                v.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doTapGesture))
                v.addGestureRecognizer(tapGesture)
            }
            
            // add a 1px border to all boxes
            if v.tag == 0 || v.tag == 1 {
                v.layer.borderWidth = 1;
                v.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    // MARK: - Gestures -
    // change die color on tap, set to default offWhite if the color doesn't exist
    @objc func doTapGesture(tapGesture: UITapGestureRecognizer)
    {
        // get the color of the tapped element
        let tapColor = tapGesture.view?.backgroundColor
        
        // set die color
        GameManager.shared.dieColor = tapColor ?? UIColor.offWhite
        
        // update die color
        GameManager.shared.updateDieColor()
        
        // change current color box
        if let currentColor = viewWithTag(1) {
            currentColor.backgroundColor = GameManager.shared.dieColor
        }
        
        // call this now to save die colors as soon as they are changed
        GameManager.shared.saveManagerData()
    }

}
