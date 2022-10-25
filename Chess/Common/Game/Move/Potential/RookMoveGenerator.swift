//
//  RookMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 24/09/2022.
//

class RookMoveGenerator {
    private let interactor = BoardInteractor()
    func potentialActions(piece: Piece, board: Board) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        var allowedFields = [Field]()
        // Up
        for i in 1 ... 7 {
            if pieceField.column + i > 7 {
                break
            }
            let field = Field(pieceField.row, pieceField.column + i)
            let pieceAhead = board.fields[field.row][field.column]
            if pieceAhead != nil {
                if pieceAhead?.color != piece.color {
                    allowedFields.append(field)
                }
                break
            } else {
                allowedFields.append(field)
            }
        }
        // Down
        for i in 1 ... 7 {
            if pieceField.column - i < 0 {
                break
            }
            let field = Field(pieceField.row, pieceField.column - i)
            let pieceAhead = board.fields[field.row][field.column]
            if pieceAhead != nil {
                if pieceAhead?.color != piece.color {
                    allowedFields.append(field)
                }
                break
            } else {
                allowedFields.append(field)
            }
        }
        // Left
        for i in 1 ... 7 {
            if pieceField.row + i > 7 {
                break
            }
            let field = Field(pieceField.row + i, pieceField.column)
            let pieceAhead = board.fields[field.row][field.column]
            if pieceAhead != nil {
                if pieceAhead?.color != piece.color {
                    allowedFields.append(field)
                }
                break
            } else {
                allowedFields.append(field)
            }
        }
        // Right
        for i in 1 ... 7 {
            if pieceField.row - i < 0 {
                break
            }
            let field = Field(pieceField.row - i, pieceField.column)
            let pieceAhead = board.fields[field.row][field.column]
            if pieceAhead != nil {
                if pieceAhead?.color != piece.color {
                    allowedFields.append(field)
                }
                break
            } else {
                allowedFields.append(field)
            }
        }
        return allowedFields.map({
            let pieceToRemove = board.fields[$0.row][$0.column]
            return Action(mainMove: (pieceField, $0),
                          sideEffects: [],
                          piecesToAdd: [],
                          piecesToRemove: pieceToRemove != nil ? [pieceToRemove!] : [])
        })
    }
}
