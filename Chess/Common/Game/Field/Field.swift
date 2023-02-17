//
//  Field.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

import Engine

struct Field: Equatable {
    let row: Int
    let column: Int
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}
