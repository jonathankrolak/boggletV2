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
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    
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
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message : {
                Text(errorMessage)
            }
        }
        Section {
            Text("Score: \(score)")
                .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("New Game", action: newGame)
                Spacer()
            }
        }
    }
    
    func makeGuess(){
        let answer = guess.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard longEnough(guess: answer) else {
            wordError(title: "Answer is too short", message: "Answer must be more than one letter.")
            return
        }
        
        guard notOriginal(guess: answer) else {
            wordError(title: "Answer is Original Word", message: "Answer can't be the original word.")
            return
        }
        
        guard real(guess: answer) else {
            wordError(title: "Not Real", message: "Each guess should be an actual word.")
            return
        }
        
        guard original(guess: answer) else {
            wordError(title: "Not Original", message: "You can not use the same word twice.")
            return
        }
        
        guard possible(guess: answer) else {
            wordError(title: "Not Possible", message: "Answer is not possible.")
            return
        }
        
        withAnimation {
            guessedWords.insert(answer, at: 0)
        }
        score += guess.count
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
        score = 0
        guessedWords.removeAll()
        startingWord = words.randomElement() ?? "succeeds"
    }
    
    func longEnough(guess : String) -> Bool{
        if guess.count > 1 || guess == "a" || guess == "i"{
            return true
        } else {
            return false
        }
    }
    
    
    func notOriginal(guess : String) -> Bool{
        if guess == startingWord{
            return false
        } else {
            return true
        }
    }
    
    func real(guess : String) -> Bool{
        let textChecker = UITextChecker()
        let range = NSMakeRange(0, guess.utf16.count)
        let misspelledRange = textChecker.rangeOfMisspelledWord(in: guess, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func original(guess : String) -> Bool{
        if guessedWords.contains(guess){
            return false
        } else {
            return true
        }

    }
    
    func possible(guess : String) -> Bool{
        return containsWord(guess: guess)
        //return true
    }
    
    func containsWord(guess : String) -> Bool{
        var baseWordArray = Array(startingWord)
            
        for character in guess {
            if let index = baseWordArray.firstIndex(of: character){
                baseWordArray.remove(at: index)
            } else {
                return false
            }
        }
        
        print(baseWordArray)
        
        return true
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

#Preview {
    ContentView()
}
