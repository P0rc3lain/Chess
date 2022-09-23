//
//  HistoryBrowser.swift
//  Chess
//
//  Created by Mateusz Stompór on 23/09/2022.
//

class HistoryBrowser {
    private let interactor = BoardInteractor()
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
}
