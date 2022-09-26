//
//  Field.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

import Foundation

struct Field: Equatable {
    let row: Int
    let column: Int
    var tuple: (Int, Int) {
        (row, column)
    }
    init(_ row: Int, _ column: Int) {
        assert(row >= 0 && row < 8 && column >= 0 && column < 8)
        self.row = row
        self.column = column
    }
}
