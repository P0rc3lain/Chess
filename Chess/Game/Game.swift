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
        guard let fromField = board.field(of: selectedPiece) else {
            fatalError("From field not set")
        }
        if canMove(piece: selectedPiece, from: fromField, to: field) {
            let moves = [Move(who: selectedPiece,
                              from: fromField.tuple,
                              to: field.tuple)]
            board.fields[fromField.row][fromField.column] = nil
            board.fields[field.row][field.column] = selectedPiece
            turn.toggle()
            currentExpectation = .piecePick
            self.selectedPiece = nil
            return moves
        }
        self.selectedPiece = nil
        currentExpectation = .piecePick
        return []
    }
    func isInCheck(color: PieceColor) -> Bool {
        return false
    }
    func canMove(piece: Piece, from: Field, to: Field) -> Bool {
        var can = false
        switch piece.type {
        case .pawn:
            can = canPawnMove(piece: piece, from: from, to: to)
        default:
            fatalError("Case not handled")
        }
        var copiedBoard = board
        
        copiedBoard.fields[to.row][to.column] = piece
        copiedBoard.fields[from.row][from.column] = nil
        return can && !isInCheck(color: piece.color)
        
    }
    func canPawnMove(piece: Piece, from: Field, to: Field) -> Bool {
        if to.row != from.row {
            fatalError("Not implemented")
        } else {
            if piece.color == .white {
                if from.column >= to.column {
                    return false
                }
                if from.column == 1 {
                    if to.column - from.column == 2 {
                        return board.fields[to.row][to.column - 1] == nil &&
                               board.fields[to.row][to.column] == nil
                    } else {
                        return board.fields[to.row][to.column] == nil
                    }
                } else if to.column - from.column == 1 {
                    return board.fields[to.row][to.column] == nil
                }
            } else {
                if from.column <= to.column {
                    return false
                }
                if from.column == 7 - 1 {
                    if abs(to.column - from.column) == 2 {
                        return board.fields[to.row][to.column + 1] == nil &&
                               board.fields[to.row][to.column] == nil
                    } else {
                        return board.fields[to.row][to.column] == nil
                    }
                } else if abs(to.column - from.column) == 1 {
                    return board.fields[to.row][to.column] == nil
                }
            }
        }
        return false
    }
}
