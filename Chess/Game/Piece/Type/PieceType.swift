//
//  PieceType.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

struct PieceType: CustomStringConvertible, Equatable {
    let coreType: CoreType
    let id: Int
    init(coreType: CoreType, id: Int) {
        self.coreType = coreType
        self.id = id
    }
    var description: String {
        coreType.rawValue + String(id)
    }
    static func rook(_ id: Int) -> PieceType {
        return PieceType(coreType: .rook, id: id)
    }
    static func pawn(_ id: Int) -> PieceType {
        return PieceType(coreType: .pawn, id: id)
    }
    static func bishop(_ id: Int) -> PieceType {
        return PieceType(coreType: .bishop, id: id)
    }
    static func knight(_ id: Int) -> PieceType {
        return PieceType(coreType: .knight, id: id)
    }
    static func queen(_ id: Int) -> PieceType {
        return PieceType(coreType: .queen, id: id)
    }
    static var king: PieceType {
        return PieceType(coreType: .king, id: 0)
    }
}
