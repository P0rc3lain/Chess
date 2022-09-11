//
//  SceneManipulator.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Engine
import simd

class SceneManipulator {
    let interactor = PNINodeInteractor()
    func performMoves(scene: PNScene, moves: [Move]) {
        for move in moves {
            let piece = findPiece(scene: scene, piece: move.who)
        }
    }
    func findPiece(scene: PNScene, piece: Piece) -> PNScenePiece? {
        interactor.forEach(node: scene.rootNode) { node in
            guard let data = node.data as? PNAnimatedNode else {
                return
            }
            let nodeName = data.name
            guard nodeName != "" else {
                return
            }
            if data.name == String(describing: piece) {
                let current = node.data.transform.value.translation
                let animation = PNKeyframeAnimation(keyFrames: [simd_float3(current.x, current.y, current.z),
                                                                simd_float3(current.x, current.y + 2, current.z),
                                                                simd_float3(current.x + 1, current.y + 2, current.z + 1),
                                                                simd_float3(current.x + 1, current.y, current.z + 1)], times: [0, 1, 2, 3], maximumTime: 4)
                data.animation = PNAnimatedCoordinateSpace(translation: animation,
                                                           rotation: PNAnimatedQuatf.defaultOrientation,
                                                           scale: PNAnimatedFloat3.defaultScale)
                data.animator.chronometer.reset()
            }
            
        }
        return nil
    }
}
