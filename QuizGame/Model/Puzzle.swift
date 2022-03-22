//
//  Puzzle.swift
//  QuizGame
//
//  Created by Roman Korobskoy on 22.03.2022.
//

import SwiftUI

// MARK: Puzzle Model

struct Puzzle: Identifiable {
    var id: String = UUID().uuidString
    var imageName: String
    var answer: String
    var jumbbledWord: String
    
    // MARK: превращаем слова в массив символов
    var letters: [Letter] = []
}

struct Letter: Identifiable {
    var id = UUID().uuidString
    var value: String
}

var puzzles: [Puzzle] = [
    Puzzle(imageName: "crown", answer: "Crown", jumbbledWord: "CUROROWKN"),
    Puzzle(imageName: "justin", answer: "Justin", jumbbledWord: "JENIUSTOK")
]
