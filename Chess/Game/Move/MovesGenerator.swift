//
//  MovesGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 13/09/2022.
//

class MovesGenerator {
    private let interactor = BoardInteractor()
    private let browser = HistoryBrowser()
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
    func allValidActions(color: PieceColor,
                         state: GameState) -> [Action] {
        let allPieces = interactor.placements(board: state.board, color: color)
        return allPieces.map({ $0.1 }).map {
            allActions(piece: $0, state: state).filter { a in
                let after = interactor.perform(board: state.board, actions: [a])
                let newState = GameState(previous: state,
                                         board: after,
                                         selectedPiece: nil,
                                         turn: state.turn.toggled(),
                                         expectation: .piecePick)
                return !isChecking(color: state.turn.toggled(), state: newState)
            }
        }.reduce([], +)
    }
    private func allActions(piece: Piece,
                            state: GameState) -> [Action] {
        switch piece.type {
        case .rook:
            return RookMoveGenerator().potentialActions(piece: piece, board: state.board)
        case .bishop:
            return BishopMoveGenerator().potentialActions(piece: piece, board: state.board)
        case .queen:
            return QueenMoveGenerator().potentialActions(piece: piece, board: state.board)
        case .king:
            return KingMoveGenerator().potentialActions(piece: piece, state: state)
        case .knight:
            return KnightMoveGenerator().potentialActions(piece: piece, board: state.board)
        case .pawn:
            return PawnMoveGenerator().potentialActions(piece: piece, state: state)
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
