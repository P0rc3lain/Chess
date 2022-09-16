//
//  MovesGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 13/09/2022.
//

class MovesGenerator {
    private let interactor = BoardInteractor()
    func pawnActionsToPerform(piece: Piece, board: Boardg) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        let forward = piece.color == .white ? 1 : -1
        let start = piece.color == .white ? 1 : 6
        let maxDisplacement = pieceField.column == start ? 2 : 1
        var actions = [Action]()
        for i in 1 ... maxDisplacement {
            let step = forward * i
            if board.fields[pieceField.row][pieceField.column + step] == nil {
                actions.append(Action(mainMove: (pieceField, Field(pieceField.row, pieceField.column + step)),
                                      sideEffects: [],
                                      piecesToAdd: [],
                                      piecesToRemove: []))
            } else {
                break
            }
        }
        let crossMoves = [1, -1].filter({
            pieceField.row + $0 >= 0 && pieceField.row + $0 < 8 &&
            pieceField.column + forward >= 0 && pieceField.column + forward < 8
        }).map({
            Field(pieceField.row + $0, pieceField.column + forward)
        }).filter({
            board.fields[$0.row][$0.column]?.color == piece.color.toggled()
        })
        for crossMove in crossMoves {
            guard let pieceToRemove = board.fields[crossMove.row][crossMove.column] else {
                fatalError("Could not find piece to remove")
            }
            actions.append(Action(mainMove: (pieceField, crossMove),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: [pieceToRemove]))
        }
        return actions
    }
    func canMoveTo(piece: Piece, field: Field, board: Board) -> Bool {
        guard let currentPosition = interactor.field(of: piece, board: board) else {
            fatalError("Piece not found")
        }
        var actions = [Action]()
        switch piece.type {
        case .pawn:
            actions = pawnActionsToPerform(piece: piece, board: board)
        default:
            fatalError("Not implemented")
        }
        let action = actions.first(where: {
            $0.mainMove.to == field && $0.mainMove.from == currentPosition
        })
        return action != nil
    }
}
