//
//  DetailVC.swift
//  Bones
//
//  Created by Student on 5/2/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // bases the textfield text off of a key passed in from menutablevc in prepare
    let details:[String: String] = [
        "New Game" : "",
        "How to Play" : "Tap the dice to select them to store them for your next roll. Once you're ready to roll, either shake the device or tap the bottom of the screen to press your luck!",
        "Rules" : " - A player must get a score of 1000 or higher for their first roll to be counted.\n\n - One (1) and five (5) are the only dice worth points on their own. A one is worth 100 points, and a five is worth 50 points.\n\n - One and five are the only dice that a player can keep before rolling more, unless there are three of the same number.\n\n - Three of the same number is worth that number multiplied by 100. For example, three dice showing four (4) is worth 400 points, despite the four having no value on its own.\n\n - Three dice showing 1 is worth 1000 points.\n\n - Four dice showing the same number follows a similar rule. For every extra die, you multiply the score from that roll by two. For example, if four dice are showing four, that is worth 800 points. If five dice are showing four, that is worth 1600 points.\n\n - If there are no valid dice selected when your turn is ended, you will go back 100 points.\n\n - Going below 1000 points results in a score of 0, meaning the player will have to start over.\n\n - If a player uses all 6 dice on their turn, they must roll all 6 dice again.\n\n - If a player rolls 1, 2, 3, 4, 5, and 6 in one roll, that is worth 1000, and that player's turn immediately comes to an end. This is the only exception to the rolling again rule.\n\n - If a player goes above 10000 points, the other players are given one turn to attempt to beat that score. If another player goes over 10000 during this \"redemption phase\", this player becomes the winner. The other players who have not taken their \"redemption\" turn now have to attempt to beat this player.",
        "Change Dice Color" : "\n\n\nSelect a color below!",
        "Credits" : "Background Music\nhttps://soundimage.org/looping-music/\n\nDice Shaking Sound Effect\nhttp://www.downloadfreesound.com/dice-sound-effects/\n\nDice Images, Coding\nZack Dunham"
    ]
    
    var currentKey = "How to Play";
    
    
    @IBOutlet weak var colorPicker: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var currentColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title to key
        title = currentKey
        
        // set label text to be equivalent to the key
        textField.text = details[currentKey]
        
        if(currentKey == "Change Dice Color") {
            colorPicker.isHidden = false
            textField.textAlignment = .center
        } else {
            colorPicker.isHidden = true
            textField.textAlignment = .left
        }
        
        // set currentColor block to be the correct color
        currentColor.backgroundColor = GameManager.shared.dieColor
        currentColor.layer.borderWidth = 1
        currentColor.layer.borderColor = UIColor.black.cgColor
    }
}
