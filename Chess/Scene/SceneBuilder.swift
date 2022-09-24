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
    func build(board: Board) -> PNScene {
        let sapeleMaterial = loader.loadMaterial(textureName: "sapele")
        let mahoganyMaterial = loader.loadMaterial(textureName: "mahogany")
        let scene = PNScene.default
        addAmbientLight(scene: scene,
                        intensity: 0.5,
                        color: simd_float3(1, 1, 1),
                        position: [0, 0, 0])
        scene.rootNode.add(child: cameraNode())
        let pieces = loadPieces(board: board, blackMaterial: mahoganyMaterial, whiteMaterial: sapeleMaterial)
        let boardPiece = loadBoard(material: sapeleMaterial)
        let all = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, -2],
                                                                           scale: [0.5, 0.5, 0.5])))
        let fields = loadBoardFields(mahogany: mahoganyMaterial, sapele: sapeleMaterial)
        all.add(children: pieces, boardPiece, fields)
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
    private func loadPieces(board: Board, blackMaterial: PNMaterial, whiteMaterial: PNMaterial) -> PNScenePiece {
        let group = PNScenePiece.make(data: PNISceneNode(transform: .identity))
        for rowIndex in 0 ..< board.fields.count {
            for columnIndex in 0 ..< board.fields[rowIndex].count {
                guard let piece = board.fields[rowIndex][columnIndex] else {
                    continue
                }
                let material = piece.color == .black ? blackMaterial : whiteMaterial
                let object = loader.loadObject(name: piece.type.coreType.rawValue.capitalized, material: material)
                let angle = Float(piece.color == .black ? 180 : 0).radians
                let orientation = simd_quatf(angle: angle, axis: [0, 1, 0]).rotationMatrix
                let rotationNode = PNScenePiece.make(data: PNISceneNode(transform: orientation))
                rotationNode.add(child: object)
                let vector = simd_float3(rowIndex, 0, columnIndex)
                let chrono = PNIChronometer(timeProducer: { Date() })
                let animator = PNIAnimator(chronometer: chrono, interpolator: PNIInterpolator(), sampler: PNISinglePlaySampler())
                let node = PNIAnimatedNode(animator: animator,
                                           animation: .static(from: .translation(vector: vector)),
                                           name: piece.description)
                let p = PNScenePiece.make(data: node)
                let groupNode = PNISceneNode(transform: .compose(translation: [-3.5, 2, 0],
                                                                 scale: [0.2, 0.2, 0.2]))
                let groupTransform = PNScenePiece.make(data: groupNode)
                p.add(child: groupTransform)
                groupTransform.add(child: rotationNode)
                group.add(child: p)
            }
        }
        return group
    }
    private func loadBoardFields(mahogany: PNMaterial, sapele: PNMaterial) -> PNNode<PNSceneNode> {
        let fields = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [-3.5, 2.5, 0],
                                                                              scale: [1, 1, 1])))
        let idA = ["a", "b", "c", "d", "e", "f", "g", "h"]
        for i in 0 ..< 8 {
            for j in 0 ..< 8 {
                let transform: simd_float4x4 = .compose(translation: [Float(i), -1.6, Float(j)],
                                                        scale: [0.5, 0.1, 0.5])
                let id = idA[i] + String(j + 1)
                let cubeNode = PNScenePiece.make(data: PNISceneNode(transform: transform,
                                                                    name: id))
                let isWhite = ((i + j) % 2) == 0
                let cube = loader.loadObject(name: "Cube", material: isWhite ? sapele : mahogany)
                cubeNode.add(child: cube)
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
