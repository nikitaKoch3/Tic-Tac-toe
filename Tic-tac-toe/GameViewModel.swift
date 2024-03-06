//
//  GameViewModel.swift
//  Tic-tac-toe
//
//  Created by Nikita Kochubey on 2/29/24.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published  var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published  var isGameBoardDisabled: Bool = false
    @Published  var alertItem: AlertItem?
}
