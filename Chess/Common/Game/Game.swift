//
//  Game.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

protocol GameDelegate: AnyObject {
    func chooseAction(action: [Action]) -> Action
}

class Game {
    private let interactor = BoardInteractor()
    private let generator = MovesGenerator()
    weak var delegate: GameDelegate?
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
                                 expectation: .field,
                                 checkState: state.checkState)
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
                                     expectation: .piece,
                                     checkState: state.checkState)
            return ([], newState)
        }
        guard let fromField = interactor.field(of: selectedPiece, board: state.board) else {
            fatalError("From field not set")
        }
        let availableActions = generator.actions(piece: selectedPiece,
                                                 desiredField: field,
                                                 state: state)
        if !availableActions.isEmpty, var action = availableActions.first {
            if availableActions.count > 1 {
                action = delegate?.chooseAction(action: availableActions) ?? availableActions.first!
            }
            let newBoard = interactor.perform(board: state.board, actions: [action])
            let newState = GameState(previous: state,
                                     board: newBoard,
                                     selectedPiece: nil,
                                     turn: state.turn.toggled(),
                                     expectation: .piece,
                                     checkState: .unknown)
            if generator.isChecking(color: state.turn.toggled(), state: newState) {
                // Cannot expose itself to check
                print("Would result in exposing itself to check")
                let newState = GameState(previous: state,
                                         board: state.board,
                                         selectedPiece: nil,
                                         turn: state.turn,
                                         expectation: .piece,
                                         checkState: state.checkState)
                return ([], newState)
            }
            var check = CheckState.unknown
            let isChecking = generator.isChecking(color: state.turn, state: newState)
            if generator.allValidActions(color: state.turn.toggled(), state: newState).isEmpty {
                if isChecking {
                    check = .checkmate
                } else {
                    check = .stalemate
                }
            } else if isChecking {
                check = .check
            } else {
                check = .noCheck
            }
            var moves = [Move]()
            moves += action.sideEffects
            for piece in action.piecesToRemove {
                guard let position = interactor.field(of: piece, board: state.board) else {
                    fatalError("Not found")
                }
                moves.append(Move(who: piece, from: position, to: nil))
            }
            moves += [Move(who: selectedPiece,
                           from: fromField,
                           to: field)]
            for addAction in action.piecesToAdd {
                moves.append(Move(who: addAction.piece, from: nil, to: addAction.field))
            }
            return (moves, GameState(previous: newState.previous,
                                     board: newState.board,
                                     selectedPiece: newState.selectedPiece,
                                     turn: newState.turn,
                                     expectation: newState.expectation,
                                     checkState: check))
        }
        let newState = GameState(previous: state,
                                 board: state.board,
                                 selectedPiece: nil,
                                 turn: state.turn,
                                 expectation: .piece,
                                 checkState: state.checkState)
        return ([], newState)
    }
}
