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
    func select(scene: PNScene, piece: Piece) {
        guard let node = findPiece(scene: scene, piece: piece) else {
            fatalError("Could not find piece")
        }
        let current = node.transform.value.translation
        var translation = PNAnimatedFloat3.defaultTranslation
        translation = PNKeyframeAnimation(keyFrames: [simd_float3(current.x, 0, current.z),
                                                      simd_float3(current.x, 0.3, current.z)],
                                          times: [0, 0.5],
                                          maximumTime: 0.5)
        node.animation = PNAnimatedCoordinateSpace(translation: translation,
                                                    rotation: PNAnimatedQuatf.defaultOrientation,
                                                    scale: PNAnimatedFloat3.defaultScale)
        node.animator.chronometer.reset()
    }
    func deselect(scene: PNScene, piece: Piece) {
        guard let node = findPiece(scene: scene, piece: piece) else {
            fatalError("Could not find piece")
        }
        let current = node.transform.value.translation
        var translation = PNAnimatedFloat3.defaultTranslation
        translation = PNKeyframeAnimation(keyFrames: [simd_float3(current.x, current.y, current.z),
                                                      simd_float3(current.x, 0, current.z)],
                                          times: [0, 0.5],
                                          maximumTime: 0.5)
        node.animation = PNAnimatedCoordinateSpace(translation: translation,
                                                    rotation: PNAnimatedQuatf.defaultOrientation,
                                                    scale: PNAnimatedFloat3.defaultScale)
        node.animator.chronometer.reset()
    }
    func performMoves(scene: PNScene, moves: [Move]) {
        for move in moves {
            guard let piece = findPiece(scene: scene, piece: move.who) else {
                fatalError("Could not find piece")
            }
            self.move(piece: piece, from: move.from?.tuple, to: move.to?.tuple)
        }
    }
    private func move(piece: PNAnimatedNode, from: (Int, Int)?, to: (Int, Int)?) {
        assert(from != nil || to != nil, "Either 'from' or 'to' must be non-nil")
        var translation = PNAnimatedFloat3.defaultTranslation
        let currentTranslation = piece.transform.value.translation
        if let from = from, let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(Float(from.0), currentTranslation.y, Float(from.1)),
                                                          simd_float3(Float(from.0), 1.5, Float(from.1)),
                                                          simd_float3(Float(to.0), 1.5, Float(to.1)),
                                                          simd_float3(to.0, 0, to.1)],
                                              times: [0, 0.5, 1, 1.5],
                                              maximumTime: 2)
        } else if let from = from {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(Float(from.0), currentTranslation.y, Float(from.1)),
                                                          simd_float3(from.0, infinity, from.1)],
                                              times: [0, 1],
                                              maximumTime: 2)
        } else if let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(to.0, infinity, to.1),
                                                          simd_float3(to.0, 0, to.1)],
                                              times: [0, 1],
                                              maximumTime: 2)
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
