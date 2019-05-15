//
//  MenuTableVC.swift
//  Bones
//
//  Created by Student on 5/2/19.
//  Copyright © 2019 Zack Dunham. All rights reserved.
//

import UIKit

class MenuTableVC: UITableViewController {

    let menuOptions:[String] = [
        "New Game",
        "How to Play",
        "Rules",
        "Change Dice Color",
        "Credits"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = menuOptions[indexPath.row]
        
        // add disclosure indicators to every menu option but new game
        if(indexPath.row != 0) {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        return cell
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            
            guard selectedRow < menuOptions.count else {
                print("\(selectedRow) is not a valid menu option")
                return
            }
            
            // set currentKey equal to menu option tapped
            if let detailVC = segue.destination as? DetailVC {
                detailVC.currentKey = menuOptions[selectedRow]
            }
        }
    }
    
    // check if new game has been pressed--if so, don't perform the segue and show an alert
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            
            if (selectedRow != 0) {
                return true
            } else {
                GameManager.shared.restart()
                let alert = UIAlertController(title: "Bones", message: "Game has been reset!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default
                    , handler: nil))
                
                self.present(alert, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
}
