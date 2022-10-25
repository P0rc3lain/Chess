//
//  Action.swift
//  Chess
//
//  Created by Mateusz Stompór on 16/09/2022.
//

struct Action {
    // Executed second
    let mainMove: (from: Field, to: Field)
    // Executed third
    let sideEffects: [Move]
    // Executed fourth
    let piecesToAdd: [(piece: Piece, field: Field)]
    // Executed first
    let piecesToRemove: [Piece]
}
