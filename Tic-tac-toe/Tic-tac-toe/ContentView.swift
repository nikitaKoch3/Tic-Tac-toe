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
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(1..<10) { element in
                        ZStack {
                            Circle()
                                .foregroundColor(.red.opacity(0.5))
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
