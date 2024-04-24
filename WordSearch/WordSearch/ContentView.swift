//
//  ContentView.swift
//  WordSearch
//
//  Created by Loiacano, Elaina on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WordSearchViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("nature") // Replace with your image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)

                VStack {
                                    // Large, bold title with a fun font (Comic Sans MS)
                                    Text("Word Search")
                                        .font(.system(size: 50, design: .serif)) // Use a fun font like serif
                                        .fontWeight(.bold) // Make the text bold
                                        .padding(.bottom, 10) // Padding below the title

                    // Word Search Grid
                    VStack {
                        ForEach(0..<viewModel.grid.count, id: \.self) { row in
                            HStack {
                                ForEach(0..<viewModel.grid[row].count, id: \.self) { column in
                                    Text(viewModel.grid[row][column])
                                        .font(.headline)
                                        .padding(5)
                                        .frame(width: 30, height: 30)
                                        .background(viewModel.selectedLetters.contains(GridPosition(row: row, column: column)) ? Color.yellow : Color.white)
                                        .onTapGesture {
                                            viewModel.handleLetterTapped(row: row, column: column)
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2)) // Background for the grid
                    .cornerRadius(10)

                    // Word Bank with light grey background
                    VStack {
                        HStack { // Centered title
                            Spacer()
                            Text("Word Bank")
                                .font(.headline)
                                .padding(.bottom, 5)
                            Spacer()
                        }

                        HStack { // Horizontal word bank
                            ForEach(viewModel.wordsToFind, id: \.self) { word in
                                Text(word)
                                    .font(.subheadline)
                                    .foregroundColor(viewModel.foundWords.contains(word) ? .green : .primary)
                                    .strikethrough(viewModel.foundWords.contains(word), color: .red)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Light grey background for word bank
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2) // Border
                        )
                    }
                    .padding(.horizontal) // Padding around word bank
                    
                    // New Game Button with light grey background
                    Button("New Game") {
                        viewModel.newGame() // Start a new game
                    }
                    .padding() // Space around the button
                    .background(Color.white.opacity(0.10)) // Light grey background
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2) // Border
                    )
                }
                .onAppear {
                    viewModel.newGame() // Initialize a new game on start
                }
            }
            .navigationBarHidden(true) // Hides the navigation bar
        }
    }
}

class WordSearchViewModel: ObservableObject {
    let wordsToFind = ["SWIFT", "UI", "WORD", "SEARCH", "GAME"]
    let gridSize = 10

    @Published var grid = [[String]]()
    @Published var selectedLetters = Set<GridPosition>()
    @Published var foundWords = Set<String>()

    func generateGrid() {
        grid = [[String]](repeating: [String](repeating: "", count: gridSize), count: gridSize)

        // Fill the grid with random letters
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                grid[i][j] = String(UnicodeScalar(Int.random(in: 65...90))!)
            }
        }

        // Place words in the grid
        for word in wordsToFind {
            let direction: (Int, Int) = (Bool.random() ? (1, 0) : (-1, 0))
            var startRow = Int.random(in: 0..<gridSize)
            var startCol = Int.random(in: 0..<gridSize)
            for letter in word {
                if startRow >= 0 && startRow < gridSize && startCol >= 0 && startCol < gridSize {
                                    grid[startRow][startCol] = String(letter)
                                    startRow += direction.0
                                    startCol += direction.1
                } else {
                    break
                }
            }
        }
    }

    func handleLetterTapped(row: Int, column: Int) {
        selectedLetters.insert(GridPosition(row: row, column: column))
        let selectedWord = selectedLetters.map { grid[$0.row][$0.column] }.joined()

        if wordsToFind.contains(selectedWord) && !foundWords.contains(selectedWord) {
                    foundWords.insert(selectedWord) // Adds found words to the set
                }
    }

    func newGame() {
        selectedLetters.removeAll()
        foundWords.removeAll()
        generateGrid()
    }
}

struct GridPosition: Hashable {
    let row: Int
    let column: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Correct preview for SwiftUI
    }
}


#Preview {
    ContentView()
}
