//
//  MovesGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 13/09/2022.
//

class MovesGenerator {
    private let interactor = BoardInteractor()
    func pawnActionsToPerform(piece: Piece,
                              board: Board,
                              previousBoard: Board?) -> [Action] {
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
        let enPassant = [1, -1].filter({
            pieceField.row + $0 >= 0 && pieceField.row + $0 < 8 &&
            pieceField.column + 2 * forward >= 0 && pieceField.column + 2 * forward < 8
        }).map({
            Field(pieceField.row + $0, pieceField.column + forward)
        }).filter({
            previousBoard?.fields[$0.row][$0.column + forward]?.color == piece.color.toggled() &&
            board.fields[$0.row][$0.column] == nil
        })
        for move in crossMoves {
            guard let pieceToRemove = board.fields[move.row][move.column] else {
                fatalError("Could not find piece to remove")
            }
            actions.append(Action(mainMove: (pieceField, move),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: [pieceToRemove]))
        }
        for move in enPassant {
            guard let pieceToRemove = board.fields[move.row][move.column - forward] else {
                fatalError("Could not find piece to remove")
            }
            actions.append(Action(mainMove: (pieceField, move),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: [pieceToRemove]))
        }
        return actions
    }
    func bishopActionsToPerform(piece: Piece, board: Board) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        var allowedFields = [Field]()
        // Up-Left
        for i in 1 ... 7 {
            if pieceField.row + i > 7 || pieceField.column + i > 7 {
                break
            }
            let field = Field(pieceField.row + i, pieceField.column + i)
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
            if pieceField.row - i < 0 || pieceField.column + i > 7 {
                break
            }
            let field = Field(pieceField.row - i, pieceField.column + i)
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
            if pieceField.row + i > 7 || pieceField.column - i < 0 {
                break
            }
            let field = Field(pieceField.row + i, pieceField.column - i)
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
            if pieceField.row - i < 0 || pieceField.column - i < 0 {
                break
            }
            let field = Field(pieceField.row - i, pieceField.column - i)
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
    func rookActionsToPerform(piece: Piece,
                              board: Board) -> [Action] {
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
    func queenActionsToPerform(piece: Piece, board: Board) -> [Action] {
        bishopActionsToPerform(piece: piece, board: board) +
        rookActionsToPerform(piece: piece, board: board)
    }
    func knightActionsToPerform(piece: Piece, board: Board) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        var moves = [
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
            let canRemove = pieceToRemove?.color != piece.color
            actions.append(Action(mainMove: (pieceField, field),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: pieceToRemove != nil && canRemove ? [pieceToRemove!] : []))
            
            
        }
        return actions
    }
    func kingActionsToPerform(piece: Piece, board: Board) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        return queenActionsToPerform(piece: piece, board: board).filter {
            $0.mainMove.to.row <= pieceField.row + 1 &&
            $0.mainMove.to.row >= pieceField.row - 1 &&
            $0.mainMove.to.column <= pieceField.column + 1 &&
            $0.mainMove.to.column >= pieceField.column - 1
        }
    }
    func findBoardBeforeOpponentMove(current state: GameState) -> GameState? {
        var previousState = state.previous
        while true {
            if previousState == nil {
                break
            }
            if state.turn != previousState?.turn {
                break
            }
            previousState = previousState?.previous
        }
        return previousState
    }
    func actions(piece: Piece,
                 desiredField field: Field,
                 state: GameState) -> [Action] {
        guard let currentPosition = interactor.field(of: piece, board: state.board) else {
            fatalError("Piece not found")
        }
        let previous = findBoardBeforeOpponentMove(current: state)
        var actions = [Action]()
        switch piece.type {
        case .rook:
            actions = rookActionsToPerform(piece: piece, board: state.board)
        case .bishop:
            actions = bishopActionsToPerform(piece: piece, board: state.board)
        case .queen:
            actions = queenActionsToPerform(piece: piece, board: state.board)
        case .king:
            actions = kingActionsToPerform(piece: piece, board: state.board)
        case .knight:
            actions = knightActionsToPerform(piece: piece, board: state.board)
        case .pawn:
            actions = pawnActionsToPerform(piece: piece,
                                           board: state.board,
                                           previousBoard: previous?.board)
        }
        return actions.filter({
            $0.mainMove.to == field && $0.mainMove.from == currentPosition
        })
    }
}
