//
//  ContentView.swift
//  Tic-tac-toe
//
//  Created by Nikita Kochubey on 1/12/24.
//

import SwiftUI

struct ContentView: View {
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn: Bool = true
    @State private var isGameBoardDisabled: Bool = false
    @State private var alertItem: AlertItem?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red.opacity(0.5))
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied (in: moves, forIndex: i) {
                                moves[i] = Move(player: isHumanTurn ? .human: .computer, boardIndex: i)
                                isGameBoardDisabled = true
                                
                                if checkWinCondition(for: .human, in: moves) {
                                    alertItem = AlertContext.humanWins
                                }
                                
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let position = determineComputerMovePostion(in: moves)
                                    moves[position] = Move(player: .computer, boardIndex: position)
                                    isGameBoardDisabled = false
                                    
                                    if checkWinCondition(for: .computer, in: moves) {
                                        alertItem = AlertContext.computerWins
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
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
                let isAvailable = !isSquareOccupied(in: <#T##[Move?]#>, forIndex: <#T##Int#>)
            }
        }
        
            func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{$0}.count == 9 && !checkWinCondition(for: .human, in: moves) && !checkWinCondition(for: .computer, in: moves)
     }
    
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
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
    ContentView()
}
