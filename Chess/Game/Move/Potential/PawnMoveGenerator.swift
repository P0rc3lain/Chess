//
//  PawnMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 23/09/2022.
//

class PawnMoveGenerator {
    private let interactor = BoardInteractor()
    private let browser = HistoryBrowser()
    func forward(color: PieceColor) -> Int {
        color == .white ? 1 : -1
    }
    func start(color: PieceColor) -> Int {
        color == .white ? 1 : 6
    }
    func end(color: PieceColor) -> Int {
        6 * forward(color: color) + start(color: color)
    }
    func potentialActions(piece: Piece,
                          state: GameState) -> [Action] {
        let board = state.board
        let previous = browser.findBoardBeforeOpponentMove(current: state)
        guard let pieceField = interactor.field(of: piece, board: board) else {
            fatalError("Invalid state")
        }
        let gathered = enPassantMoves(piece: piece,
                                      field: pieceField,
                                      board: state.board,
                                      previousBoard: previous?.board) +
        forwardMoves(piece: piece, field: pieceField, board: state.board) +
        crossMoves(piece: piece, field: pieceField, board: state.board)
        return rewrittenPromotionMoves(piece: piece, actions: gathered)
    }
    private func enPassantMoves(piece: Piece,
                                field pieceField: Field,
                                board: Board,
                                previousBoard: Board?) -> [Action] {
        let forward = forward(color: piece.color)
        var actions = [Action]()
        let enPassant = [1, -1].filter({
            pieceField.row + $0 >= 0 && pieceField.row + $0 < 8 &&
            pieceField.column + 2 * forward >= 0 && pieceField.column + 2 * forward < 8
        }).map({
            Field(pieceField.row + $0, pieceField.column + forward)
        }).filter({
            previousBoard?.fields[$0.row][$0.column + forward]?.color == piece.color.toggled() &&
            board.fields[$0.row][$0.column] == nil
        })
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
    private func forwardMoves(piece: Piece, field pieceField: Field, board: Board) -> [Action] {
        let forward = forward(color: piece.color)
        let start = start(color: piece.color)
        let maxDisplacement = pieceField.column == start ? 2 : 1
        var actions = [Action]()
        for i in 1 ... maxDisplacement {
            let step = forward * i
            if board.fields[pieceField.row][pieceField.column + step] == nil {
                let destination = Field(pieceField.row, pieceField.column + step)
                actions.append(Action(mainMove: (pieceField, destination),
                                      sideEffects: [],
                                      piecesToAdd: [],
                                      piecesToRemove: []))
            } else {
                break
            }
        }
        return actions
    }
    private func rewrittenPromotionMoves(piece: Piece, actions: [Action]) -> [Action] {
        actions.map { action in
            if action.mainMove.to.column == end(color: piece.color) {
                // rewrite
                let field = action.mainMove.to
                let newPiece = Piece(color: piece.color, type: .bishop(2))
                return Action(mainMove: action.mainMove,
                              sideEffects: [],
                              piecesToAdd: [(newPiece, field)],
                              piecesToRemove: [piece] + action.piecesToRemove)
            } else {
                return action
            }
        }
    }
    private func crossMoves(piece: Piece, field pieceField: Field, board: Board) -> [Action] {
        var actions = [Action]()
        let forward = forward(color: piece.color)
        let crossMoves = [1, -1].filter({
            pieceField.row + $0 >= 0 && pieceField.row + $0 < 8 &&
            pieceField.column + forward >= 0 && pieceField.column + forward < 8
        }).map({
            Field(pieceField.row + $0, pieceField.column + forward)
        }).filter({
            board.fields[$0.row][$0.column]?.color == piece.color.toggled()
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
        return actions
    }
}
