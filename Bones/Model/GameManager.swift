//
//  DieManager.swift
//  Bones
//
//  Created by Zack D. on 4/22/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class GameManager{
    
    static let shared = GameManager()
    
    // MARK: - Ivars-
    // create an array to store them in
    var dieArray: [DiceView] = []
    
    // initialize rolls, used to keep track of rolls
    var rolls: [[Int]] = []
    // score array
    var scores: [Int] = [0, 0]
    
    // score values to eliminate magic numbers
    let rollScores:[[Int]] = [
        [100,200,1000,2000,4000,8000],  // scores for 1s
        [200,400,800,1600],             // scores for 2s
        [300,600,1200,2400],            // scores for 3s
        [400,800,1600,3200],            // scores for 4s
        [50,100,500,1000,2000,4000],    // scores for 5s
        [600,1200,2400,4800],           // scores for 6s
        [-100]                          // backwards score
    ]
    
    var currScore:UILabel = UILabel()
    var currentPlayer = 0
    var scoreLabels:[UILabel] = []
    var scoreArea:UIView = UIView()
    
    // vars for colors to make changing easier if necessary
    var dieColor = UIColor.offWhite
    let selectedColor = UIColor.green
    let previouslySelectedColor = UIColor.darkGreen
    
    // custom messages
    let straightMsg:String = "Rolled a straight! You must end your turn!"
    
    // userdefaults constant
    let defaults = UserDefaults.standard
    
    // MARK: - Functions -
    // private init to make GameManager a singleton
    private init(){}
    
    // MARK: - Die Selection/Marking -
    // countDice returns an array of ints that shows how many die of a certain value are selected
    func countDice(checkWhite: Bool)->[Int] {
        var diceCount:[Int] = [0, 0, 0, 0, 0, 0]
        
        for d in dieArray {
            if(d.backgroundColor == selectedColor || (checkWhite == true && d.backgroundColor != previouslySelectedColor)) {
                switch(d.image)
                {
                // if the die reads "1"
                case UIImage(named: "1")!:
                    diceCount[0] += 1 // increment first position in array
                    break
                    
                // rinse and repeat for other dice
                case UIImage(named: "2")!:
                    diceCount[1] += 1
                    break
                case UIImage(named: "3")!:
                    diceCount[2] += 1
                    break
                case UIImage(named: "4")!:
                    diceCount[3] += 1
                    break
                case UIImage(named: "5")!:
                    diceCount[4] += 1
                    break
                case UIImage(named: "6")!:
                    diceCount[5] += 1
                    break
                    
                // default will essentially be an error handler
                default:
                    print("Dice subview does not read a number from 1-6!")
                    break
                }
            }
        }
        return diceCount
    }
    
    // make sure dice selected are valid
    func dieSelectValidation(store: Bool)->Bool {
        let count:[Int] = countDice(checkWhite: false)
        
        // a straight is a valid move, but we don't want to allow for rerolling after getting a straight
        if(straightChecker()) {
            updateScoreText(customMsg: straightMsg) // display custom message
            return false
        }
        
        // check for illegal moves (2, 3, 4, 6)
        if (count[1] == 1 || count[1] == 2) { return false }
        if (count[2] == 1 || count[2] == 2) { return false }
        if (count[3] == 1 || count[3] == 2) { return false }
        if (count[5] == 1 || count[5] == 2) { return false }
        
        // make sure there are any dice selected
        if (count[0] == 0 && count[1] == 0 && count[2] == 0 && count[3] == 0 && count[4] == 0 && count[5] == 0) {
            return false
        }
        
        // if store is true, add to rolls
        if (store) {
            rolls.append(count)
        }
        
        // return true if all checks have passed
        return true
    }
    
    // checks for straights
    func straightChecker()->Bool{
        let count:[Int] = countDice(checkWhite: true)
        
        if (count[0] == 1 && count[1] == 1 && count[2] == 1 && count[3] == 1 && count[4] == 1 && count[5] == 1) {
            return true
        }
        
        return false
    }
    
    // checks if all dice are selected
    func allSelectCheck()->Bool{
        if ((dieArray[0].backgroundColor == selectedColor || dieArray[0].backgroundColor == previouslySelectedColor) &&
            (dieArray[1].backgroundColor == selectedColor || dieArray[1].backgroundColor == previouslySelectedColor) &&
            (dieArray[2].backgroundColor == selectedColor || dieArray[2].backgroundColor == previouslySelectedColor) &&
            (dieArray[3].backgroundColor == selectedColor || dieArray[3].backgroundColor == previouslySelectedColor) &&
            (dieArray[4].backgroundColor == selectedColor || dieArray[4].backgroundColor == previouslySelectedColor) &&
            (dieArray[5].backgroundColor == selectedColor || dieArray[5].backgroundColor == previouslySelectedColor))
        {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Score Calculation -
    func scoreCalc()->Int {
        
        var score = 0
        var backward = false
        
        rolls.append(countDice(checkWhite: false))
        
        // loop through rolls
        for r in rolls {
            // add roll score
            let scrAdd = scoreAdd(count: r)
            
            // if scoreAdd is less than 0 for any roll, set backward to true
            if (scrAdd > 0) {
                score += scrAdd
            } else {
                backward = true
            }
        }
        
        // clear the rolls array
        rolls.removeAll()
        
        // if backward is true, subtract 100 from total score
        if (backward) {
            return -100
        } else {
            return score
        }
    }
    
    // adds score appropriately based on number of dice
    func scoreAdd(count: [Int])->Int {
        var score = 0
        
        // straight is worth 1000 points
        if (straightChecker()) {
            return 1000
        }
        
        // check for 1s
        switch(count[0])
        {
        case 1: score += rollScores[0][0]; break;
        case 2: score += rollScores[0][1]; break;
        case 3: score += rollScores[0][2]; break;
        case 4: score += rollScores[0][3]; break;
        case 5: score += rollScores[0][4]; break;
        case 6: score += rollScores[0][5]; break;
            
        default: break
        }
        
        // check for 2s
        switch (count[1])
        {
        case 3: score += rollScores[1][0]; break;
        case 4: score += rollScores[1][1]; break;
        case 5: score += rollScores[1][2]; break;
        case 6: score += rollScores[1][3]; break;
            
        default: break
        }
        
        // check for 3s
        switch (count[2])
        {
        case 3: score += rollScores[2][0]; break;
        case 4: score += rollScores[2][1]; break;
        case 5: score += rollScores[2][2]; break;
        case 6: score += rollScores[2][3]; break;
            
        default: break
        }
        
        // check for 4s
        switch (count[3])
        {
        case 3: score += rollScores[3][0]; break;
        case 4: score += rollScores[3][1]; break;
        case 5: score += rollScores[3][2]; break;
        case 6: score += rollScores[3][3]; break;
            
        default: break
        }
        
        // check for 5s
        switch (count[4])
        {
        case 1: score += rollScores[4][0]; break;
        case 2: score += rollScores[4][1]; break;
        case 3: score += rollScores[4][2]; break;
        case 4: score += rollScores[4][3]; break;
        case 5: score += rollScores[4][4]; break;
        case 6: score += rollScores[4][5]; break;
            
        default: break
        }
        
        // check for 6s
        switch (count[5])
        {
        case 3: score += rollScores[5][0]; break;
        case 4: score += rollScores[5][1]; break;
        case 5: score += rollScores[5][2]; break;
        case 6: score += rollScores[5][3]; break;
            
        default: break
        }
        
        // go backwards by 100 if score is 0
        if (score == 0) {
            score = rollScores[6][0]
        }

        return score
    }
    
    // MARK: - VC Helpers -
    // show the current player by turning their box red
    func indicateCurrentPlayer(){
        // set both to default
        for v in scoreArea.subviews {
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.black.cgColor
            v.layer.cornerRadius = 5
        }
        
        // indicate current player's turn
        scoreArea.subviews[currentPlayer].layer.borderWidth = 3
        scoreArea.subviews[currentPlayer].layer.borderColor = UIColor.red.cgColor
    }
    
    // update text at top to show accurate score after die selection
    func updateScoreText()
    {
        var score = 0
        
        // loop through rolls
        for r in rolls {
            let scrAdd = scoreAdd(count: r)
            
            if(scrAdd > 0) {
                score += scrAdd // only add scoreAdd to total if it is not negative
            }
        }
        
        // counts current dice
        let countScore = scoreAdd(count: countDice(checkWhite: false))
        
        if (countScore > 0) {
            score += countScore // only add countScore to total if it is not negative
        }
        
        currScore.text = "Your Roll is Worth: \(score)"
    }
    
    // takes in a param to set a custom score for the text
    func updateScoreText(customScore: Int)
    {
        currScore.text = "Your Roll is Worth: \(customScore)"
    }
    
    // takes in a param to set a custom message -- used when game is over, when a straight is rolled, etc.
    func updateScoreText(customMsg: String)
    {
        currScore.text = customMsg
    }
    
    // update color of the dice to match dieColor
    func updateDieColor()
    {
        // set active color
        for d in dieArray {
            // only change the color if it's not selected
            if (d.backgroundColor != selectedColor && d.backgroundColor != previouslySelectedColor) {
                d.backgroundColor = dieColor
            }
        }
    }
    
    // MARK: - Rolling and Restarting -
    // handles legality checking and rerolling of all dice if necessary
    func roll()
    {
        // make sure the move is valid
        if (dieSelectValidation(store: true) == true)
        {
            // check if all dice have been selected so all of them can be rerolled
            if (allSelectCheck() == true)
            {
                for d in dieArray {
                    d.backgroundColor = dieColor
                }
            }
            
            for d in dieArray {
                d.reroll()
            }
            
            // play roll sound
            AudioManager.shared.dicePlayer.currentTime = 0
            AudioManager.shared.dicePlayer.play()
        }
        
        // save userdefaults data
        saveManagerData()
    }
    
    // restart the game
    func restart(){        
        // reset dice
        for d in dieArray {
            d.backgroundColor = dieColor
            d.reroll()
            d.isUserInteractionEnabled = true
        }
        
        // set player 1 to be current player
        currentPlayer = 0
        indicateCurrentPlayer()
        
        // set scores to be 0
        scores[0] = 0
        scores[1] = 0
        for l in scoreLabels{
            l.text = "0"
        }
        
		rolls.removeAll()
        updateScoreText(customScore: 0) // set customScore to 0
        saveManagerData()
    }
    
    // MARK: - User Defaults Saving/Loading -
    // save important things to userdefaults
    func saveManagerData()
    {
        defaults.set(true, forKey: "defaultsStored")
        
        defaults.set(rolls, forKey: "SavedRolls")
        defaults.set(scores, forKey: "SavedScores")
        defaults.set(currentPlayer, forKey: "SavedPlayer")
        
        // get the rgba values for the default dice color to save to userdefaults
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        // use getRed to read the colors of the current dieColor
        dieColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // save to userdefaults
        defaults.set(r, forKey: "SavedRed")
        defaults.set(g, forKey: "SavedGreen")
        defaults.set(b, forKey: "SavedBlue")
        defaults.set(a, forKey: "SavedAlpha")
        
        saveDiceUserDefaults()
    }
    
    // saves dice number and their colors
    func saveDiceUserDefaults()
    {
       
        var dieNumbers:[String] = ["1", "1", "1", "1", "1", "1"]
        var dieColors:[String] = ["dieColor","dieColor","dieColor","dieColor","dieColor","dieColor"]
        
        for i in 0...5 {
            switch(dieArray[i].image)
            {
            // if the die reads "1"
            case UIImage(named: "1")!:
                dieNumbers[i] = "1"
                break
                
            // rinse and repeat for other dice
            case UIImage(named: "2")!:
                dieNumbers[i] = "2"
                break
            case UIImage(named: "3")!:
                dieNumbers[i] = "3"
                break
            case UIImage(named: "4")!:
                dieNumbers[i] = "4"
                break
            case UIImage(named: "5")!:
                dieNumbers[i] = "5"
                break
            case UIImage(named: "6")!:
                dieNumbers[i] = "6"
                break
                
            // default will essentially be an error handler
            default:
                print("Dice subview does not read a number from 1-6!")
                break
            }
            
            switch(dieArray[i].backgroundColor)
            {
            // if the die is default dieColor
            case dieColor:
                dieColors[i] = "dieColor"
                break
                
            // rinse and repeat for other colors
            case selectedColor:
                dieColors[i] = "selectedColor"
                break
            case previouslySelectedColor:
                dieColors[i] = "previouslySelectedColor"
                break
                
            // default will essentially be an error handler
            default:
                print("Dice color is invalid!")
                break
            }
        }
        
        // set userdefaults
        defaults.set(dieNumbers, forKey: "SavedDieNumbers")
        defaults.set(dieColors, forKey: "SavedDieColors")
    }
    
    // load data from userdefaults
    func loadManagerData()
    {
        rolls = defaults.object(forKey: "SavedRolls") as! [[Int]]
        scores = defaults.object(forKey: "SavedScores") as! [Int]
        
        // read in the color
        dieColor = UIColor(red: defaults.object(forKey: "SavedRed") as! CGFloat, green: defaults.object(forKey: "SavedGreen") as! CGFloat, blue: defaults.object(forKey: "SavedBlue") as! CGFloat, alpha: defaults.object(forKey: "SavedAlpha") as! CGFloat)
        
        let dieNumbers = defaults.object(forKey: "SavedDieNumbers") as! [String]
        let dieColors = defaults.object(forKey: "SavedDieColors") as! [String]
        
        // set die images and colors 
        for i in 0...5 {
            dieArray[i].image = UIImage(named: dieNumbers[i])
            switch(dieColors[i]){
            case "dieColor":
                dieArray[i].backgroundColor = dieColor
                break
            case "selectedColor":
                dieArray[i].backgroundColor = selectedColor
                break
            case "previouslySelectedColor":
                dieArray[i].backgroundColor = previouslySelectedColor
                break
            default:
                dieArray[i].backgroundColor = UIColor.black
                break
            }
        }
        
        // update score text to correctly display the current roll score
        updateScoreText()
    }
}
