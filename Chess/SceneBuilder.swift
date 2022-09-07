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
        for row in loadPieces(material: sapeleMaterial) {
            whites.add(children: row)
        }
        let black = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, 7],
                                                                             rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]),
                                                                             scale: .one)))
        var mahoganyPieces = loadPieces(material: mahoganyMaterial)
        let translation = PNIAnimatedValue<simd_float3>(keyFrames: [[0, 0, 0],
                                                                    [0, 2, 0],
                                                                    [3, 2, 2],
                                                                    [3, 0, 2]],
                                                        times: [0, 2, 4, 6],
                                                        maximumTime: 8)
        let space = PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(translation),
                                              rotation: PNAnyAnimatedValue(PNIAnimatedValue.defaultOrientation),
                                              scale: PNAnyAnimatedValue(PNIAnimatedValue.defaultScale))
        let node = PNScenePiece.make(data: PNIAnimatedNode(animator: PNIAnimator.default, animation: space))
        node.add(child: mahoganyPieces[0][0])
        mahoganyPieces[0][0] = node

        for row in mahoganyPieces {
            black.add(children: row)
        }
        
        let all = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, -2],
                                                                           scale: [0.5, 0.5, 0.5])))
        let fields = loadBoardFields(mahogany: mahoganyMaterial, sapele: sapeleMaterial)
        all.add(children: whites, black, board, fields)
        scene.rootNode.add(child: all)
        scene.environmentMap = device.makeTextureSolidCube(color: [1, 1, 1, 1])
        
        addDirectionalLight(scene: scene,
                            intensity: 1.5,
                            color: [1, 1, 1],
                            direction: simd_float3(0, -1, 0).normalized,
                            castsShadows: false)
        return scene
    }
    private func loadBoard(material: PNMaterial) -> PNNode<PNSceneNode> {
        let board = loader.loadObject(name: "Board", material: material)
        let boardTransform = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 1.9, 3.5],
                                                                                      scale: [0.17, 0.2, 0.17])))
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
    private func loadPieces(material: PNMaterial) -> [[PNScenePiece]] {
        let queen = loader.loadObject(name: "Queen", material: material)
        let king = loader.loadObject(name: "King", material: material)
        var nodes = [
            [loader.loadObject(name: "Rook", material: material),
             loader.loadObject(name: "Knight", material: material),
             loader.loadObject(name: "Bishop", material: material),
             king,
             queen,
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
        for j in 0 ..< 2 {
            for i in 0 ..< 8 {
                let transform = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [-3.5 + Float(i), 2, Float(j)],
                                                                                         scale: [0.2, 0.2, 0.2])))
                transform.add(child: nodes[j][i])
                nodes[j][i] = transform
            }
        }
        return nodes
    }
    private func loadBoardFields(mahogany: PNMaterial, sapele: PNMaterial) -> PNNode<PNSceneNode> {
        
        let fields = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [-3.5, 2.5, 0],
                                                                              scale: [1, 1, 1])))
        for i in 0 ..< 8 {
            for j in 0 ..< 8 {
                let cubeNode = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [Float(i), -1.6, Float(j)],
                                                                                        scale: [0.5, 0.1, 0.5])))
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
        let camera = PNOrthographicCamera(bound: PNBound(min: [-5, -5, 0.01], max: [5, 5, 20]))
        let rotation = simd_float4x4(simd_quatf(angle: Float(45).radians, axis: [0, 1, 0])) *
                       simd_float4x4(simd_quatf(angle: Float(45).radians, axis: [-1, 0, 0]))
        let translation = simd_float4x4.translation(vector: [0, 0, 5])
        let node = PNICameraNode(camera: camera,
                                 transform: rotation * translation)
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
    private func addDirectionalLight(scene: PNScene,
                                     intensity: Float,
                                     color: simd_float3,
                                     direction: simd_float3,
                                     castsShadows: Bool) {
        let light = PNIDirectionalLight(color: color, intensity: intensity, direction: direction, castsShadows: castsShadows)
        scene.directionalLights.append(light)
    }
}
