//
//  Game.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

enum UserExpectation {
    case piecePick
    case fieldPick
}

class Game {
    var board = Board.initial
    var currentExpectation = UserExpectation.piecePick
}
