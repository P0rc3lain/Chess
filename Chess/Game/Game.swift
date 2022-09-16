//
//  Game.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

class Game {
    var board = Board.initial
    private(set) var selectedPiece: Piece?
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
        guard let fromField = BoardInteractor().field(of: selectedPiece, board: board) else {
            fatalError("From field not set")
        }
        if MovesGenerator().canMoveTo(piece: selectedPiece, field: field, board: board) {
            let actions = MovesGenerator().pawnActionsToPerform(piece: selectedPiece, board: board)
            guard let action = actions.first(where: { $0.mainMove.to == field }) else {
                fatalError("Error")
            }
            let newBoard = BoardInteractor().perform(board: board, actions: [action])
            board = newBoard
            turn.toggle()
            currentExpectation = .piecePick
            self.selectedPiece = nil
            let moves = [Move(who: selectedPiece,
                              from: fromField,
                              to: field)]
            return moves
        }
        self.selectedPiece = nil
        currentExpectation = .piecePick
        return []
    }
}
