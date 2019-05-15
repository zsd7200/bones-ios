//
//  DiceView.swift
//  Bones
//
//  Created by Student on 4/11/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class DiceView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // constant array of dice images
    let dieImages:[UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!
    ]
    
    required init?(coder aDecoder: NSCoder) {
        // call initializer and setup dice
        super.init(coder: aDecoder)
        setupDie()
    }
    
    // private setup function
    private func setupDie()
    {
        // add tap gesture
        self.isUserInteractionEnabled = true;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doTapGesture));
        self.addGestureRecognizer(tapGesture)
        
        // set bg to dieColor
        self.backgroundColor = GameManager.shared.dieColor
        
        // add border
        self.layer.borderWidth = 3;
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10
        
        // roll dice so they start in a random state, only if there are no userdefaults
        if(GameManager.shared.defaults.bool(forKey: "defaultsStored") == false) {
            reroll()
        }

    }
    
    // reroll function
    func reroll()
    {
        // if die is selected, change it to dark green to lock it in
        if self.backgroundColor == GameManager.shared.selectedColor {
            self.backgroundColor = GameManager.shared.previouslySelectedColor
        } else if self.backgroundColor == GameManager.shared.dieColor { // otherwise, if it is dieColor, reroll it
            // die face animation
            self.animationImages = self.dieImages.shuffled() // shuffled allows for the dice rolling animation to seem more random
            self.animationDuration = 0.75
            self.animationRepeatCount = 1
            
            // animate
            spin()
            self.startAnimating()
            
            // set random die image to be the actual roll
            self.image = dieImages[Int.random(in: 0...5)]
        }
    }
    
    // function to rotate the dice
    func spin(){
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(.pi * 2.0)
        rotate.duration = 0.5
        rotate.repeatCount = 1.55
        self.layer.add(rotate, forKey: nil)
    }
    
    // MARK: - Gestures -
    // change die color on tap
    @objc func doTapGesture(tapGesture: UITapGestureRecognizer)
    {
        let die = tapGesture.view! as UIView
        if die.backgroundColor == GameManager.shared.dieColor {
            die.backgroundColor = GameManager.shared.selectedColor
        } else if die.backgroundColor != GameManager.shared.previouslySelectedColor {
            die.backgroundColor = GameManager.shared.dieColor
        }
        
        // update score data and save dice user defaults
        GameManager.shared.updateScoreText()
        GameManager.shared.saveDiceUserDefaults()
    }
    
}
