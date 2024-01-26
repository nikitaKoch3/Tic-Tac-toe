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
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let position = determineComputerMovePostion(in: moves)
                                    moves[position] = Move(player: .computer, boardIndex: position)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func isSquareOccupied (in moves: [Move?], forIndex index: Int) -> Bool {
        return !moves.contains(where: { $0?.boardIndex == index})
    }
    func determineComputerMovePostion(in moves: [Move?]) -> Int {
        var position = Int .random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: position) {
            position = Int.random(in: 0..<9)
        }
        return position
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
