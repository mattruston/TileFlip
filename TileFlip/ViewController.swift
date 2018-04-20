//
//  ViewController.swift
//  TileFlip
//
//  Created by Matthew Ruston on 3/27/18.
//  Copyright © 2018 MattRuston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let board = [
            [false, false, false],
            [false, true, false],
            [false, false, false]
        ]
        
        let game = FlipGame(board: board)
        AStarSearch(problem: game, initialState: game.currentState) { (actions) in
            print(actions)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

