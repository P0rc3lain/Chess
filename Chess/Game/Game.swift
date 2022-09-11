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
    private var turn = PieceColor.white
    var currentExpectation = UserExpectation.piecePick
    func selectPiece(piece: Piece?) -> [Move] {
        guard let piece = piece else {
            return []
        }
        guard piece.color == turn else {
            return []
        }
        selectedPiece = piece
        currentExpectation = .fieldPick
        return []
    }
    func selectField(field: Field?) -> [Move] {
        guard let selectedPiece = selectedPiece else {
            return []
        }
        guard let field = field else {
            self.selectedPiece = nil
            currentExpectation = .piecePick
            return []
        }
        currentExpectation = .piecePick
        let moves = [Move(who: selectedPiece,
                          from: board.field(of: selectedPiece)!.tuple,
                          to: field.tuple)]
        turn.toggle()
        self.selectedPiece = nil
        return moves
    }
}
