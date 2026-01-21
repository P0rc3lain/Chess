//
//  Copyright © 2026 Mateusz Stompór. All rights reserved.
//

class GameSnapshot: Codable {
    var board: Board
    var selectedPiece: Piece?
    var turn: PieceColor
    var expectation: PickExpectation
    var checkState: CheckState
    init(board: Board,
         selectedPiece: Piece? = nil,
         turn: PieceColor,
         expectation: PickExpectation,
         checkState: CheckState) {
        self.board = board
        self.selectedPiece = selectedPiece
        self.turn = turn
        self.expectation = expectation
        self.checkState = checkState
    }
}
