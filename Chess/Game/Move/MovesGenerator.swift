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
            let pieceToRemove = board.fields[move.row][move.column - forward]
            if pieceToRemove == nil {
                continue
            }
            actions.append(Action(mainMove: (pieceField, move),
                                  sideEffects: [],
                                  piecesToAdd: [],
                                  piecesToRemove: [pieceToRemove!]))
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
    func wasEverMoved(piece: Piece, state: GameState) -> Bool {
        guard let currentPosition = interactor.field(of: piece, board: state.board) else {
            fatalError("Piece not found")
        }
        var currentState: GameState? = state
        while currentState != nil {
            guard let previousPosition = interactor.field(of: piece, board: currentState!.board) else {
                return true
            }
            if currentPosition != previousPosition {
                return true
            }
            currentState = currentState?.previous
        }
        return false
    }
    func checkingMoves(color: PieceColor, state: GameState) -> [Action] {
        let king = Piece(color: color.toggled(), type: .king)
        guard let kingField = interactor.field(of: king, board: state.board) else {
            fatalError("King not found")
        }
        let pieces = interactor.placements(board: state.board, color: color)
        return pieces.map { (field, piece) in
            actions(piece: piece, desiredField: kingField, state: state)
        }.reduce([], +)
    }
    func isChecking(color: PieceColor, state: GameState) -> Bool {
        !checkingMoves(color: color, state: state).isEmpty
    }
    func allActions(piece: Piece,
                    state: GameState) -> [Action] {
        let previous = findBoardBeforeOpponentMove(current: state)
        switch piece.type {
        case .rook:
            return rookActionsToPerform(piece: piece, board: state.board)
        case .bishop:
            return bishopActionsToPerform(piece: piece, board: state.board)
        case .queen:
            return queenActionsToPerform(piece: piece, board: state.board)
        case .king:
            return kingActionsToPerform(piece: piece, board: state.board)
        case .knight:
            return knightActionsToPerform(piece: piece, board: state.board)
        case .pawn:
            return pawnActionsToPerform(piece: piece,
                                        board: state.board,
                                        previousBoard: previous?.board)
        }
    }
    func actions(piece: Piece,
                 desiredField field: Field,
                 state: GameState) -> [Action] {
        guard let currentPosition = interactor.field(of: piece, board: state.board) else {
            fatalError("Piece not found")
        }
        return allActions(piece: piece, state: state).filter({
            $0.mainMove.to == field && $0.mainMove.from == currentPosition
        })
    }
}
