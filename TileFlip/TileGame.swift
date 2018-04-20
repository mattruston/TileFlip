//
//  TileGame.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import Foundation

//TODO: There might be a better way for represeting actions, since this isnt even exhaustive,
// but for this quick project I want it to conform to my previous search function
enum FlipAction: Action {
    case toggle(x: Int, y: Int)
    
    static func ==(lhs: FlipAction, rhs: FlipAction) -> Bool {
        switch (lhs, rhs) {
        case let (.toggle(lx, ly), .toggle(rx, y: ry)):
            return lx == rx && ly == ry
        }
    }
}

typealias Board = [[Bool]]
struct FlipGameState: GameState {
    var board = Board()
    
    let size: Int
    
    init(size: Int = 3) {
        self.size = size
        
        for x in 0..<size {
            board.append([])
            for _ in 0..<size {
                board[x].append(false)
            }
        }
    }
    
    init(board: Board, size: Int) {
        self.board = board
        self.size = size
    }
    
    var hashValue: Int {
        var stringValue = ""
        for row in 0..<size {
            for column in 0..<size {
                let tile = board[row][column]
                let character = tile ? "t" : "f"
                stringValue.append(character)
            }
        }
        
        return stringValue.hashValue
    }
    
    static func ==(lhs: FlipGameState, rhs: FlipGameState) -> Bool {
        guard lhs.size == rhs.size else {
            return false
        }
        
        for x in 0..<lhs.board.count {
            if lhs.board[x] != rhs.board[x] {
                return false
            }
        }
        
        return true
    }
}

class FlipGame: Problem {
    
    typealias S = FlipGameState
    typealias A = FlipAction
    
    var currentState: FlipGameState
    
    var size: Int {
        return currentState.size
    }
    
    init(_ size: Int) {
        currentState = FlipGameState(size: size)
    }
    
    init(board: Board) {
        let size = board.count
        currentState = FlipGameState(board: board, size: size)
    }
    
    
    //MARK: - Problem Protocol Methods
    
    func getLegalActions(_ state: FlipGameState) -> [FlipAction] {
        guard state.board.count > 0 else {
            return []
        }
        
        var actions: [FlipAction] = []
        
        for x in 0..<size {
            for y in 0..<size {
                actions.append(FlipAction.toggle(x: x, y: y))
            }
        }
        
        return actions
    }
    
    func stateSuccessor(_ state: FlipGameState, for action: FlipAction) -> FlipGameState {
        var newState = state
        
        takeActionOn(&newState, action: action)
        
        return newState
    }
    
    func isGoal(_ state: FlipGameState) -> Bool {
        for row in 0..<state.size {
            for column in 0..<state.size {
                let tile = state.board[row][column]
                if tile == false {
                    return false
                }
            }
        }
        
        return true
    }
    
    func hueristic(_ state: FlipGameState) -> Double {
        let cost = 0.0
        
        return cost
    }
    
    
    //MARK: - Helper Methods
    
    fileprivate func takeActionOn(_ state: inout FlipGameState, action: FlipAction) {
        let actions = getLegalActions(state)
        
        guard actions.contains(where: {$0 == action})  else {
            return
        }
        
        switch action {
        case let .toggle(x, y):
            state.board[x][y] = !state.board[x][y]
            if x + 1 < size {
                state.board[x + 1][y] = !state.board[x + 1][y]
            }
            if x - 1 >= 0 {
                state.board[x - 1][y] = !state.board[x - 1][y]
            }
            if y + 1 < size {
                state.board[x][y + 1] = !state.board[x][y + 1]
            }
            if y - 1 >= 0 {
                state.board[x][y - 1] = !state.board[x][y - 1]
            }
        }
    }
    
    
    //MARK: - Current Game Methods
    
    func takeAction(action: FlipAction) {
        takeActionOn(&currentState, action: action)
    }
}
