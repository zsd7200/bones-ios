//
//  ViewController.swift
//  Bones
//
//  Created by Student on 4/11/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Ivars -
    // get references to storyboard elements
    @IBOutlet weak var die1: DiceView!
    @IBOutlet weak var die2: DiceView!
    @IBOutlet weak var die3: DiceView!
    @IBOutlet weak var die4: DiceView!
    @IBOutlet weak var die5: DiceView!
    @IBOutlet weak var die6: DiceView!
    
    // score area UIView
    @IBOutlet weak var scoreArea: UIView!

    // end turn button
    @IBOutlet weak var endTurnButt: UIBarButtonItem!
    
    // score labels
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    var scoreLabels: [UILabel] = []
    
    @IBOutlet weak var currScore: UILabel!
    
    // used for checking if one player has gotten over the goal (10000)
    var endgame:Bool = false
    
    // used for changing the end turn button to a newGame button after the game has ended
    var newGame:Bool = false
    
    // set some numbers
    let minScore = 1000
    let minSubtractedScore = 950        // can't use 1000 here because 1050 - 100 is a possibility with game scoring
    let scoreGoal = 10000
    
    // MARK: - Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        loadUserDefaults()
        GameManager.shared.indicateCurrentPlayer() // indicate current player after starting userdefaults
        GameManager.shared.updateDieColor()
        GameManager.shared.saveManagerData()
    }
    
    private func loadUserDefaults() {
        // this if checks if defaults have been stored before
        if(GameManager.shared.defaults.bool(forKey: "defaultsStored"))
        {
            GameManager.shared.loadManagerData()
            GameManager.shared.currentPlayer = GameManager.shared.defaults.object(forKey: "SavedPlayer") as! Int
            GameManager.shared.indicateCurrentPlayer()
            
            scoreLabels[0].text = String(GameManager.shared.scores[0])
            scoreLabels[1].text = String(GameManager.shared.scores[1])
        }
    }
    
    // basic setting up stuff and styling
    private func basicSetup()
    {
        // append dice to array
        GameManager.shared.dieArray.append(die1)
        GameManager.shared.dieArray.append(die2)
        GameManager.shared.dieArray.append(die3)
        GameManager.shared.dieArray.append(die4)
        GameManager.shared.dieArray.append(die5)
        GameManager.shared.dieArray.append(die6)
        
        // append score labels to scoreLabels
        scoreLabels.append(p1Score)
        scoreLabels.append(p2Score)
        
        // set score area bg to be white
        scoreArea.backgroundColor = UIColor.white
        
        // set instance of current score text
        GameManager.shared.currScore = currScore
        
        // set more instances
        GameManager.shared.scoreLabels = scoreLabels
        GameManager.shared.scoreArea = scoreArea
        
        // play music
        AudioManager.shared.bgPlayer.play()
    }
    
    // MARK: - Gestures/Motion -
    // check for shaking motion and reroll
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (GameManager.shared.straightChecker() == true) {                 // players must be forced to take a straight
            GameManager.shared.updateScoreText(customMsg: GameManager.shared.straightMsg)
        } else {                                                            // otherwise reroll the dice
            GameManager.shared.roll()
        }
    }
    
    // MARK: - Buttons -
    // end turn condition
    @IBAction func endTurn()
    {
        // refresh endgame variable to prevent weird things happening if you select new game from menu after someone has won
        if (GameManager.shared.scores[0] < scoreGoal && GameManager.shared.scores[1] < scoreGoal) {
            endgame = false
        }
        
        if (newGame == false && (GameManager.shared.allSelectCheck() == false || GameManager.shared.straightChecker() == true))
        {
            let score = GameManager.shared.scoreCalc()
            
            // make sure first roll has over 1000 points
            if (GameManager.shared.scores[GameManager.shared.currentPlayer] == 0) {
                if (score >= minScore) {
                    GameManager.shared.scores[GameManager.shared.currentPlayer] += score
                }
            } else {
                GameManager.shared.scores[GameManager.shared.currentPlayer] += score
            }
            
            // set score to 0 if score goes below 1000
            if (GameManager.shared.scores[GameManager.shared.currentPlayer] <= minSubtractedScore) {
                GameManager.shared.scores[GameManager.shared.currentPlayer] = 0
            }
            
            GameManager.shared.scoreLabels[GameManager.shared.currentPlayer].text = String(GameManager.shared.scores[GameManager.shared.currentPlayer])
            
            // if the current player has reached over 10000 and endgame is false
            if (GameManager.shared.scores[GameManager.shared.currentPlayer] >= scoreGoal && endgame == false) {
                
                GameManager.shared.updateScoreText(customMsg: "Last turn!")
                endgame = true
                
            } else if (endgame == true) { // if endgame is true, pick a winner and change end turn to newGame
                
                if(GameManager.shared.scores[0] > GameManager.shared.scores[1]) {
                    GameManager.shared.updateScoreText(customMsg: "Player 1 wins!")
                } else {
                    GameManager.shared.updateScoreText(customMsg: "Player 2 wins!")
                }
                
                // change end turn button to new game button
                endTurnButt.title = "New Game"
                newGame = true
                
                // turn off dice interaction to "freeze" the game until restarted
                for d in GameManager.shared.dieArray {
                    d.isUserInteractionEnabled = false
                }
                
            } else {
                GameManager.shared.updateScoreText(customScore: 0) // set customScore to 0
            }
            
            // only have dice reroll if newGame is false (if game is still going)
            if (newGame == false) {
                for d in GameManager.shared.dieArray {
                    
                    d.backgroundColor = GameManager.shared.dieColor
                    d.reroll()
                    
                    // play shake sound
                    AudioManager.shared.dicePlayer.currentTime = 0
                    AudioManager.shared.dicePlayer.play()
                }
            }
            
            // if current player is 0, set it to 1
            // otherwise, set it to 0
            GameManager.shared.currentPlayer = GameManager.shared.currentPlayer == 0 ? 1 : 0
            GameManager.shared.indicateCurrentPlayer() // update player border
            
        } else if (GameManager.shared.allSelectCheck() == true && GameManager.shared.straightChecker() == false) {       // force the player to roll again
            GameManager.shared.updateScoreText(customMsg: "You must roll again!")
        } else if (newGame == true) {
            // set end turn button to its original state
            endTurnButt.title = "End Turn"
            newGame = false
            GameManager.shared.restart()
        }
        
        GameManager.shared.saveManagerData()
    }
}

