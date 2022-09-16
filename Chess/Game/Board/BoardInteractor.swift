//
//  BoardInteractor.swift
//  Chess
//
//  Created by Mateusz Stompór on 14/09/2022.
//

class BoardInteractor {
    func field(of piece: Piece, board: Board) -> Field? {
        for rowIndex in 0 ..< board.fields.count {
            for columnIndex in 0 ..< board.fields[rowIndex].count {
                if board.fields[rowIndex][columnIndex] == piece {
                    return Field(rowIndex, columnIndex)
                }
            }
        }
        return nil
    }
    func perform(board: Board, actions: [Action]) -> Board {
        var fields = board.fields
        for action in actions {
            for toRemove in action.piecesToRemove {
                guard let position = field(of: toRemove, board: board) else {
                    fatalError("Could not find \(toRemove)")
                }
                fields[position.row][position.column] = nil
            }
            let to = action.mainMove.to
            let from = action.mainMove.from
            fields[to.row][to.column] = fields[from.row][from.column]
            fields[from.row][from.column] = nil
            for request in action.piecesToAdd {
                fields[request.field.row][request.field.column] = request.piece
            }
            for _ in action.sideEffects {
                fatalError("Not implemented")
            }
        }
        return Board(fields: fields)
    }
}
