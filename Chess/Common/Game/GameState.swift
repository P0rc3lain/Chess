//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import SwiftData

@Model
class GameState {
    var all: [GameSnapshot]
    var last: GameSnapshot {
        guard let lastState = all.last else {
            fatalError("Invalid state, game must have at least one board")
        }
        return lastState
    }
    var board: Board {
        last.board
    }
    var selectedPiece: Piece? {
        last.selectedPiece
    }
    var turn: PieceColor {
        last.turn
    }
    var expectation: PickExpectation {
        last.expectation
    }
    var checkState: CheckState {
        last.checkState
    }
    var previous: GameState? {
        guard all.count > 1 else {
            return nil
        }
        return GameState(all: Array(all.dropLast()))
    }
    private init(all: [GameSnapshot]) {
        self.all = all
    }
    init(previous: GameState?,
         board: Board,
         selectedPiece: Piece?,
         turn: PieceColor,
         expectation: PickExpectation,
         checkState: CheckState) {
        let allPrevious = previous?.all ?? []
        let current = GameSnapshot(board: board,
                                   selectedPiece: selectedPiece,
                                   turn: turn,
                                   expectation: expectation,
                                   checkState: checkState)
        all = allPrevious + [current]
    }
    static var initial: GameState {
        GameState(previous: nil,
                  board: .initial,
                  selectedPiece: nil,
                  turn: .white,
                  expectation: .piece,
                  checkState: .noCheck)
    }
}
