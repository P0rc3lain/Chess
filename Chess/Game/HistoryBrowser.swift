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
    func historySequence(state: GameState) -> [GameState] {
        var allStates = [GameState]()
        var current: GameState? = state
        while current != nil {
            allStates.append(current!)
            current = current?.previous
        }
        return allStates
    }
    func allIdsUsed(type: CoreType, color: PieceColor, state: GameState) -> Set<Int> {
        let ids = historySequence(state: state).map({ state in
            let placements = interactor.placements(board: state.board, color: color, type: type)
            let ids = placements.map({ (field, piece) in
                piece.type.id
            })
            return Set<Int>(ids)
        })
        return ids.reduce(Set<Int>(), { $0.union($1) })
    }
    func nextId(type: CoreType, color: PieceColor, state: GameState) -> Int {
        let all = allIdsUsed(type: type, color: color, state: state)
        guard let maximalValue = all.max() else {
            return 0
        }
        return maximalValue + 1
    }
}
