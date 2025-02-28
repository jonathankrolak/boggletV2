//
//  ContentView.swift
//  BoggletV2
//
//  Created by HPro2 on 2/27/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var words = [String]()
    @State private var guessedWords = [String]()
    @State private var startingWord = ""
    @State private var guess = ""
    
    var body: some View {
        NavigationStack {
            Spacer()
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                Text("Your Word: \(startingWord)")
                    .fontWeight(.bold)
            }
            List {
                Section {
                    TextField("Enter your word", text: $guess)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section {
                    ForEach(guessedWords, id: \.self) {
                        word in HStack{
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle("Bogglet")
            .onSubmit(makeGuess)
            .onAppear(perform: startGame)
        }
    }
    
    func makeGuess(){
        let answer = guess.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            guessedWords.insert(answer, at: 0)
        }
        
        guess = ""
    }
    
    func startGame(){
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"){
            if let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8){
                words = fileContents.components(separatedBy: "\n")
                newGame()
                return
            }
        }
        fatalError("Could not load the file")
    }
    
    func newGame(){
        guessedWords.removeAll()
        startingWord = words.randomElement() ?? "succeeds"
    }
    
}

#Preview {
    ContentView()
}
