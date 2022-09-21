//
//  Game.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

class Game {
    private let interactor = BoardInteractor()
    private let generator = MovesGenerator()
    func select(piece: Piece?, state: GameState) -> (moves: [Move], newState: GameState) {
        guard let piece = piece else {
            return ([], state)
        }
        guard piece.color == state.turn else {
            return ([], state)
        }
        let newState = GameState(previous: state,
                                 board: state.board,
                                 selectedPiece: piece,
                                 turn: state.turn,
                                 expectation: .fieldPick)
        return ([], newState)
    }
    func select(field: Field?, state: GameState) -> (moves: [Move], newState: GameState) {
        guard let selectedPiece = state.selectedPiece else {
            return ([], state)
        }
        guard let field = field else {
            let newState = GameState(previous: state,
                                     board: state.board,
                                     selectedPiece: nil,
                                     turn: state.turn,
                                     expectation: .piecePick)
            return ([], newState)
        }
        guard let fromField = interactor.field(of: selectedPiece, board: state.board) else {
            fatalError("From field not set")
        }
        if let action = generator.actions(piece: selectedPiece,
                                          desiredField: field,
                                          state: state).first {
            let newBoard = interactor.perform(board: state.board, actions: [action])
            let newState = GameState(previous: state,
                                     board: newBoard,
                                     selectedPiece: nil,
                                     turn: state.turn.toggled(),
                                     expectation: .piecePick)
            if generator.isChecking(color: state.turn.toggled(), state: newState) {
                // Cannot expose itself to check
                print("Would result in exposing itself to check")
                let newState = GameState(previous: state,
                                         board: state.board,
                                         selectedPiece: nil,
                                         turn: state.turn,
                                         expectation: .piecePick)
                return ([], newState)
            }
            if generator.isChecking(color: state.turn, state: newState) {
                print("Check against \(state.turn.toggled())")
            }
            var moves = [Move]()
            for piece in action.piecesToRemove {
                guard let position = interactor.field(of: piece, board: state.board) else {
                    fatalError("Not found")
                }
                moves.append(Move(who: piece, from: position, to: nil))
            }
            moves += [Move(who: selectedPiece,
                           from: fromField,
                           to: field)]
            return (moves, newState)
        }
        let newState = GameState(previous: state,
                                 board: state.board,
                                 selectedPiece: nil,
                                 turn: state.turn,
                                 expectation: .piecePick)
        return ([], newState)
    }
}
