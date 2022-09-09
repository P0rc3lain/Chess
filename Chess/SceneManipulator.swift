//
//  SceneManipulator.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Engine

class SceneManipulator {
    let interactor = PNINodeInteractor()
    func performMoves(scene: PNScene, moves: [Move]) {
        for move in moves {
            let piece = findPiece(scene: scene, piece: move.who)
        }
    }
    func findPiece(scene: PNScene, piece: Piece) -> PNScenePiece? {
        interactor.forEach(node: scene.rootNode) { node in
            let nodeName = node.data.name
            guard nodeName != "" else {
                return
            }
            if node.data.name == String(describing: piece) {
                node.data.transform.value.translation += [0, 2, 0]
            }
        }
        return nil
    }
}
