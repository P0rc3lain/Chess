//
//  SceneBuilder.swift
//  Chess
//
//  Created by Mateusz Stompór on 06/09/2022.
//

import Metal
import MetalKit
import Engine
import simd

class SceneBuilder {
    private let device: MTLDevice
    private let loader: ResourceLoader
    init(device: MTLDevice) {
        self.device = device
        self.loader = ResourceLoader(device: device)
    }
    func build() -> PNScene {
        let sapeleMaterial = loader.loadMaterial(textureName: "sapele")
        let mahoganyMaterial = loader.loadMaterial(textureName: "mahogany")
        let scene = PNScene.default
        addAmbientLight(scene: scene,
                        intensity: 0.5,
                        color: simd_float3(1, 1, 1),
                        position: [0, 0, 0])
        scene.rootNode.add(child: cameraNode())
        let board = loadBoard(material: sapeleMaterial)
        let whites = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: .zero,
                                                                              scale: [1, 1, 1])))
        whites.add(child: loadPieces(material: sapeleMaterial))
        let blackPiecesTransform = PNTransform.composeTRS(translation: [0, 0, 7],
                                                          rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]),
                                                          scale: .one)
        let black = PNScenePiece.make(data: PNISceneNode(transform: blackPiecesTransform))
        black.add(child: loadPieces(material: mahoganyMaterial))
        let all = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, -2],
                                                                           scale: [0.5, 0.5, 0.5])))
        let fields = loadBoardFields(mahogany: mahoganyMaterial, sapele: sapeleMaterial)
        all.add(children: whites, black, board, fields)
        scene.rootNode.add(child: all)
        scene.environmentMap = device.makeTextureSolidCube(color: [1, 1, 1, 1])
        scene.directionalLights.append(PNIDirectionalLight(color: [1, 1, 1],
                                                           intensity: 1.5,
                                                           direction: simd_float3(0, -1, 0).normalized,
                                                           castsShadows: false))
        return scene
    }
    private func loadBoard(material: PNMaterial) -> PNNode<PNSceneNode> {
        let board = loader.loadObject(name: "Board", material: material)
        let boardTransform = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0.02, 1.9, 3.46],
                                                                                      scale: [0.168, 0.2, 0.168])))
        boardTransform.add(child: board)
        return boardTransform
    }
    private func addOmniLight(scene: PNScene,
                              intensity: Float,
                              influenceRadius: Float,
                              color: simd_float3,
                              position: simd_float3,
                              castsShadows: Bool) {
        let light = PNIOmniLight(color: color,
                                 intensity: intensity,
                                 influenceRadius: influenceRadius,
                                 castsShadows: castsShadows)
        let treeNode = PNScenePiece.make(data: PNIOmniLightNode(light: light,
                                                                transform: .translation(vector: position)),
                                         parent: scene.rootNode)
        scene.rootNode.children.append(treeNode)
    }
    private func loadPieces(material: PNMaterial) -> PNScenePiece {
        let isWhite = material.name == "sapele"
        let prefix = isWhite ? "White" : "Black"
        let names = [
            [ prefix + "Rook" + "0",
              prefix + "Knight" + "0",
              prefix + "Bishop" + "0",
              prefix + "King" + "0",
              prefix + "Queen" + "0",
              prefix + "Bishop" + "1",
              prefix + "Knight" + "1",
              prefix + "Rook" + "1"
            ],
            [
                prefix + "Pawn" + "0",
                prefix + "Pawn" + "1",
                prefix + "Pawn" + "2",
                prefix + "Pawn" + "3",
                prefix + "Pawn" + "4",
                prefix + "Pawn" + "5",
                prefix + "Pawn" + "6",
                prefix + "Pawn" + "7"
            ]
        ]
        let nodes = [
            [loader.loadObject(name: "Rook", material: material),
             loader.loadObject(name: "Knight", material: material),
             loader.loadObject(name: "Bishop", material: material),
             loader.loadObject(name: "King", material: material),
             loader.loadObject(name: "Queen", material: material),
             loader.loadObject(name: "Bishop", material: material),
             loader.loadObject(name: "Knight", material: material),
             loader.loadObject(name: "Rook", material: material)],
            [loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material),
             loader.loadObject(name: "Pawn", material: material)]
        ]
        let n = PNScenePiece.make(data: PNISceneNode(transform: .identity))
        for j in 0 ..< 2 {
            for i in 0 ..< 8 {
                let vector = simd_float3(Float(i), 0, Float(j))
                let animator = PNIAnimator(chronometer: PNIChronometer(timeProducer: {
                    Date()
                }), interpolator: PNIInterpolator(), sampler: PNISinglePlaySampler())
                let node = PNIAnimatedNode(animator: animator, animation: .static(from: .translation(vector: vector)), name: names[j][i])
                let p = PNScenePiece.make(data: node)
                let groupNode = PNISceneNode(transform: .compose(translation: [-3.5, 2, 0],
                                                                 scale: [0.2, 0.2, 0.2]))
                let groupTransform = PNScenePiece.make(data: groupNode)
                p.add(child: groupTransform)
                groupTransform.add(child: nodes[j][i])
                n.add(child: p)
            }
        }
        return n
    }
    private func loadBoardFields(mahogany: PNMaterial, sapele: PNMaterial) -> PNNode<PNSceneNode> {
        let fields = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [-3.5, 2.5, 0],
                                                                              scale: [1, 1, 1])))
        let idA = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let idB = ["1", "2", "3", "4", "5", "6", "7", "8"]
        for i in 0 ..< 8 {
            for j in 0 ..< 8 {
                let id = idA[7 - i] + idB[j]
                let cubeNode = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [Float(i), -1.6, Float(j)],
                                                                                        scale: [0.5, 0.1, 0.5]),
                                                                    name: id))
                let isWhite = ((i + j) % 2) == 0
                let cubeMahogany = loader.loadObject(name: "Cube", material: mahogany)
                let cubeSapele = loader.loadObject(name: "Cube", material: sapele)
                cubeNode.add(child: isWhite ? cubeSapele : cubeMahogany)
                fields.add(child: cubeNode)
            }
        }
        return fields
    }
    private func cameraNode() -> PNScenePiece {
        let camera = PNOrthographicCamera(bound: PNBound(min: [-5, -5, 0.01], max: [5, 5, 100]))
        let rotation = simd_quatf(angle: Float(45).radians, axis: [0, 1, 0]) *
                       simd_quatf(angle: Float(45).radians, axis: [-1, 0, 0])
        let translation = simd_float4x4.translation(vector: [0, 0, 5])
        let animator = PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                                   interpolator: PNIInterpolator(),
                                   sampler: PNISinglePlaySampler(),
                                   windingOrder: .rts)
        let transform = PNAnimatedTransform.static(from:  translation * simd_float4x4(rotation))
        let node = PNIAnimatedCameraNode(camera: camera,
                                         animator: animator,
                                         animation: transform)
        return PNScenePiece.make(data: node)
    }
    private func addAmbientLight(scene: PNScene,
                                 intensity: Float,
                                 color: simd_float3,
                                 position: simd_float3) {
        let light = PNIAmbientLight(diameter: 40, color: color, intensity: intensity)
        let node = PNIAmbientLightNode(light: light, transform: .translation(vector: position))
        let treeNode = PNScenePiece.make(data: node, parent: scene.rootNode)
        scene.rootNode.children.append(treeNode)
    }
}
