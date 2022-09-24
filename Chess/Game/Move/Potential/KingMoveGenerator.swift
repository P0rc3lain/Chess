//
//  KingMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 24/09/2022.
//

class KingMoveGenerator {
    private let interactor = BoardInteractor()
    private let browser = HistoryBrowser()
    private let queenGenerator = QueenMoveGenerator()
    func potentialActions(piece: Piece, state: GameState) -> [Action] {
        guard let pieceField = interactor.field(of: piece, board: state.board) else {
            fatalError("Invalid state")
        }
        var standard = queenGenerator.potentialActions(piece: piece, board: state.board).filter {
            $0.mainMove.to.row <= pieceField.row + 1 &&
            $0.mainMove.to.row >= pieceField.row - 1 &&
            $0.mainMove.to.column <= pieceField.column + 1 &&
            $0.mainMove.to.column >= pieceField.column - 1
        }
        if !browser.wasEverMoved(piece: piece, state: state) {
            let rookA = Piece(color: piece.color, type: .rook(0))
            let rookB = Piece(color: piece.color, type: .rook(1))
//            if let rookAField = interactor.field(of: rookA, board: state.board),
//               !wasEverMoved(piece: rookA, state: state) {
//                if (rookAField.row + 1 ..< pieceField.row).allSatisfy({ index in
//                    return state.board.fields[index][rookAField.column] == nil
//                }) {
//                    standard += [
//                        Action(mainMove: (pieceField, Field(rookAField.row + 1, rookAField.column)),
//                               sideEffects: [Move(who: rookA,
//                                                  from: rookAField,
//                                                  to: Field(rookAField.row + 2, rookAField.column))],
//                               piecesToAdd: [],
//                               piecesToRemove: [])
//                    ]
//                }
//            }
//            if let rookBField = interactor.field(of: rookB, board: state.board),
//               !wasEverMoved(piece: rookB, state: state) {
//                if (pieceField.row + 1 ..< rookBField.row).allSatisfy({ index in
//                    return state.board.fields[index][rookBField.column] == nil
//                }) {
//                    standard += [
//                        Action(mainMove: (pieceField, Field(rookBField.row - 2, rookBField.column)),
//                               sideEffects: [Move(who: rookB,
//                                                  from: rookBField,
//                                                  to: Field(rookBField.row - 3, rookBField.column))],
//                               piecesToAdd: [],
//                               piecesToRemove: [])
//                    ]
//                }
//            }
        }
        return standard
    }
}
