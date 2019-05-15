//
//  ScoreAreaView.swift
//  Bones
//
//  Created by Student on 4/23/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class ScoreAreaView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        // call initializer and setup gestures
        super.init(coder: aDecoder)
        addGestures()
    }
    
    func addGestures() {
        // add tap gesture
        self.isUserInteractionEnabled = true;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doTapGesture));
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gestures -
    // reroll on score area tap
    @objc func doTapGesture(tapGesture: UITapGestureRecognizer)
    {
        GameManager.shared.roll()
    }

}
