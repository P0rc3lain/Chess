//
//  KnightMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 24/09/2022.
//

class KnightMoveGenerator {
    private let interactor = BoardInteractor()
    func potentialActions(piece: Piece, board: Board) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        let moves = [
            (pieceField.row + 2, pieceField.column + 1),
            (pieceField.row + 2, pieceField.column - 1),
            (pieceField.row - 2, pieceField.column + 1),
            (pieceField.row - 2, pieceField.column - 1),
            (pieceField.row - 1, pieceField.column - 2),
            (pieceField.row - 1, pieceField.column + 2),
            (pieceField.row + 1, pieceField.column - 2),
            (pieceField.row + 1, pieceField.column + 2)
        ]
        var actions = [Action]()
        for move in moves {
            if move.0 < 0 || move.0 > 7 || move.1 < 0 || move.1 > 7 {
                continue
            }
            let field = Field(move.0, move.1)
            let pieceToRemove = board.fields[move.0][move.1]
            if pieceToRemove?.color == piece.color {
                continue
            }
            let canRemove = pieceToRemove?.color != piece.color
            let removablePieces = pieceToRemove != nil && canRemove ? [pieceToRemove!] : []
            actions.append(Action(mainMove: (pieceField, field),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: removablePieces))
            
            
        }
        return actions
    }
}
