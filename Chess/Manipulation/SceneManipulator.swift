//
//  SceneManipulator.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Engine
import Metal
import simd

class SceneManipulator {
    private let interactor = PNINodeInteractor()
    private let infinity: Int = 20
    private let builder: SceneBuilder
    init(device: MTLDevice) {
        self.builder = SceneBuilder(device: device)
    }
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
        var delay: PNTimeInterval = 0
        for move in moves {
            var piece: PNAnimatedNode! = findPiece(scene: scene, piece: move.who)
            if piece == nil {
                let sceneNode = builder.add(piece: move.who, position: simd_float3([move.to!.row, infinity, move.to!.column]))
                scene.rootNode.children[2].add(child: sceneNode)
                piece = sceneNode.data as? PNAnimatedNode
            }
            self.move(piece: piece, from: move.from, to: move.to, delay: delay)
            delay += 1
        }
    }
    private func move(piece: PNAnimatedNode, from: Field?, to: Field?, delay: PNTimeInterval) {
        assert(from != nil || to != nil, "Either 'from' or 'to' must be non-nil")
        var translation = PNAnimatedFloat3.defaultTranslation
        let currentTranslation = piece.transform.value.translation
        if let from = from, let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(Float(from.row), currentTranslation.y, Float(from.column)),
                                                          simd_float3(Float(from.row), 1.5, Float(from.column)),
                                                          simd_float3(Float(to.row), 1.5, Float(to.column)),
                                                          simd_float3(to.row, 0, to.column)],
                                              times: [delay + 0, delay + 0.5, delay + 1, delay + 1.5],
                                              maximumTime: delay + 2)
        } else if let from = from {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(Float(from.row), currentTranslation.y, Float(from.column)),
                                                          simd_float3(from.row, infinity, from.column)],
                                              times: [delay + 0, delay + 1],
                                              maximumTime: delay + 2)
        } else if let to = to {
            translation = PNKeyframeAnimation(keyFrames: [simd_float3(to.row, infinity, to.column),
                                                          simd_float3(to.row, 0, to.column)],
                                              times: [delay + 0, delay + 1],
                                              maximumTime: delay + 2)
        }
        piece.animation = PNAnimatedCoordinateSpace(translation: translation,
                                                    rotation: PNAnimatedQuatf.defaultOrientation,
                                                    scale: PNAnimatedFloat3.defaultScale)
        piece.animator.chronometer.reset()
    }
    private func findPiece(scene: PNScene, piece: Piece) -> PNAnimatedNode? {
        scene.rootNode.findNode(where: {
            $0.data.name == PieceParser().dump(piece: piece)
        })?.data as? PNAnimatedNode
    }
}
