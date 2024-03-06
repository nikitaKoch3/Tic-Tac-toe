//
//  ContentView.swift
//  Tic-tac-toe
//
//  Created by Nikita Kochubey on 1/12/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red.opacity(0.5))
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied (in: viewModel.moves, forIndex: i) {
                                viewModel.moves[i] = Move(player: .human, boardIndex: i)
                                viewModel.isGameBoardDisabled = true
                                
                                if checkWinCondition(for: .human, in: viewModel.moves) {
                                    viewModel.alertItem = AlertContext.humanWins
                                }
                                
                                if checkForDraw(in: viewModel.moves) {
                                    viewModel.alertItem = AlertContext.draw
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let position = determineComputerMovePostion(in: viewModel.moves)
                                        viewModel.moves[position] = Move(player: .computer, boardIndex: position)
                                    viewModel.isGameBoardDisabled = false
                                    
                                    if checkWinCondition(for: .computer, in: viewModel.moves) {
                                        viewModel.alertItem = AlertContext.computerWins
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: viewModel.$alertItem) { Item in
                Alert(title: Item.title, message: Item.message, dismissButton: .default(Item.buttonTitle, action: {
                    print()
                    resetGame()
                }))
            }
        }
    }
    
    
    
    func isSquareOccupied (in moves: [Move?], forIndex index: Int) -> Bool {
        return !moves.contains(where: { $0?.boardIndex == index})
    }
    
    
    
    func determineComputerMovePostion(in moves: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        let center = 4
        if !isSquareOccupied(in: moves, forIndex: 4) {
            return center
        }
        
        var position = Int.random(in: 0..<9)
        while !isSquareOccupied(in: moves, forIndex: position) {
            position = Int.random(in: 0..<9)
        }
        return position
    }
    
    
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{$0}.count == 9 && !checkWinCondition(for: .human, in: moves) && !checkWinCondition(for: .computer, in: moves)
    }
    
    
    func resetGame() {
        viewModel.moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    GameView()
}
