//
//  Piece.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Foundation

import Foundation

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

struct Piece: CustomStringConvertible {
    let color: PieceColor
    let type: PieceType
    var description: String {
        color.rawValue + String(describing: type)
    }
    init(color: PieceColor, type: PieceType) {
        self.color = color
        self.type = type
    }
    init?(literal: String) {
        let pattern = "^(Black|White)(Rook|Knight|Bishop|Queen|King|Pawn)(\\d)?$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: literal, range: NSRange(location: 0, length: literal.count))
        guard let match = matches.first else {
            return nil
        }
        
        let color = PieceColor(rawValue: String(literal[match.range(at: 1)]))
        let pieceType = PieceType(type: String(literal[match.range(at: 2)]),
                                  index: (match.numberOfRanges > 2 ? Int(String(literal[match.range(at: 3)])) : nil))
        guard let color = color,
              let pieceType = pieceType else {
            return nil
        }
        self.color = color
        self.type = pieceType
        return nil
    }
}
