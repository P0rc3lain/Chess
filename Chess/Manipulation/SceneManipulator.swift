//
//  SceneManipulator.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Engine
import simd

class SceneManipulator {
    private let interactor = PNINodeInteractor()
    private let infinity: Int = 20
    func performMoves(scene: PNScene, moves: [Move]) {
        for move in moves {
            guard let piece = findPiece(scene: scene, piece: move.who) else {
                fatalError("Could not find piece")
            }
            self.move(piece: piece, from: move.from, to: move.to)
        }
    }
    private func move(piece: PNAnimatedNode, from: (Int, Int)?, to: (Int, Int)?) {
        assert(from != nil || to != nil, "Either 'from' or 'to' must be non-nil")
        var translation = PNAnimatedFloat3.defaultTranslation
        if let from = from, let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(from.0, 0, from.1),
                                                          simd_float3(from.0, 2, from.1),
                                                          simd_float3(to.0, 2, to.1),
                                                          simd_float3(to.0, 0, to.1)],
                                              times: [0, 1, 2, 3],
                                              maximumTime: 4)
        } else if let from = from {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(from.0, 0, from.1),
                                                          simd_float3(from.0, infinity, from.1)],
                                              times: [0, 2],
                                              maximumTime: 4)
        } else if let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(to.0, infinity, to.1),
                                                          simd_float3(to.0, 0, to.1)],
                                              times: [0, 2],
                                              maximumTime: 4)
        }
        piece.animation = PNAnimatedCoordinateSpace(translation: translation,
                                                    rotation: PNAnimatedQuatf.defaultOrientation,
                                                    scale: PNAnimatedFloat3.defaultScale)
        piece.animator.chronometer.reset()
    }
    private func findPiece(scene: PNScene, piece: Piece) -> PNAnimatedNode? {
        scene.rootNode.findNode(where: {
            $0.data.name == String(describing: piece)
        })?.data as? PNAnimatedNode
    }
}
