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
    private var selectedPiece: Piece?
    var currentExpectation = UserExpectation.piecePick
    func selectPiece(piece: Piece?) -> [Move] {
        selectedPiece = piece
        currentExpectation = .fieldPick
        return []
    }
    func selectField(field: Field?) -> [Move] {
        if selectedPiece == nil {
            return []
        }
        currentExpectation = .piecePick
        let moves = [Move(who: selectedPiece!,
                          from: board.field(of: selectedPiece!)!.tuple,
                          to: field!.tuple)]
        selectedPiece = nil
        return moves
    }
}
