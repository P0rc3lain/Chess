//
//  Move.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

struct Move: Equatable {
    let who: Piece
    let from: Field?
    let to: Field?
    static func == (lhs: Move, rhs: Move) -> Bool {
        lhs.who == rhs.who &&
        lhs.from == rhs.from &&
        lhs.to == rhs.to
    }
}
