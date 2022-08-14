//
//  ViewController.swift
//  Demo
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Cocoa
import Engine
import ModelIO
import MetalKit
import MetalBinding

class ViewController: NSViewController {
    private var engine: PNEngine!
    private var engineView: PNView!
    private var cameraNode: PNIAnimatedCameraNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        engineView = view as? PNView
        engine = engineView.engine
        listenForKeyboardEvents()
        createScene()
    }
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "f":
            view.window?.toggleFullScreen(self)
        case "p":
            cameraNode?.animator.chronometer.toggle()
        default:
            break
        }
    }
    private func cameraAnimation() -> PNAnimatedCoordinateSpace {
        let translation = PNIAnimatedValue<simd_float3>(keyFrames: [[0, -2, -10], [2, -3, -10], [3, -4, -10], [2, -3, -10], [0, -2, -10]],
                                                        times: [0, 2, 4, 6, 8],
                                                        maximumTime: 10)
        let orientation = PNIAnimatedValue<simd_quatf>(keyFrames: [simd_quatf(angle: Float(90).radians, axis: [0, 1, 0]),
                                                                   simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0]),
                                                                   simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])],
                                                       times: [0, 3, 6], maximumTime: 10)
        return PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(translation),
                                         rotation: PNAnyAnimatedValue(orientation),
                                         scale: PNAnyAnimatedValue(PNIAnimatedValue.defaultScale))
    }
    private func addCamera(scene: PNScene, position: simd_float3) -> PNIAnimatedCameraNode {
        let camera = PNCamera(nearPlane: 0.01,
                              farPlane: 20,
                              fovRadians: Float(80).radians,
                              aspectRatio: Float(2880/1800))
        let node = PNIAnimatedCameraNode(camera: camera,
                                         animator: PNIAnimator.default,
                                         animation: cameraAnimation())
        let treeNode = PNNode(data: node, parent: scene.rootNode)
        scene.rootNode.children.append(treeNode)
        return node
    }
//    private func addOmniLight(scene: PNScene,
//                              intensity: Float,
//                              color: simd_float3,
//                              position: simd_float3,
//                              castsShadows: Bool) {
//        let light = PNIOmniLight(color: color, intensity: intensity, castsShadows: castsShadows)
//        let treeNode = PNNode(data: PNIOmniLightNode(light: light, transform: .translation(vector: position)),
//                              parent: scene.rootNode)
//        scene.rootNode.children.append(treeNode)
//    }
    private func addAmbientLight(scene: PNScene,
                                 intensity: Float,
                                 color: simd_float3,
                                 position: simd_float3) {
        let light = PNIAmbientLight(diameter: 40, color: color, intensity: intensity)
        let node = PNIAmbientLightNode(light: light, transform: .translation(vector: position))
        let treeNode = PNNode(data: node, parent: scene.rootNode)
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
//    private func addSpotLight(scene: PNScene,
//                              intensity: Float,
//                              color: simd_float3,
//                              coneAngle: Float,
//                              position: simd_float3,
//                              castsShadows: Bool) {
//        let light = PNISpotLight(color: color, intensity: intensity, coneAngle: coneAngle, castsShadows: castsShadows)
//        let node = PNISpotLightNode(light: light, transform: .translation(vector: position))
//        let treeNode = PNNode(data: node, parent: scene.rootNode)
//        scene.rootNode.children.append(treeNode)
//    }
//    private func planeAnimation() -> PNAnimatedCoordinateSpace {
//        let scale: Float = 0.1
//        let height: Float = 2
//        let translation = PNIAnimatedValue<simd_float3>(keyFrames: [[0, height, 0], [3, height, 0], [-3, height, 0], [0, height, 0]],
//                                                        times: [0, 2, 4, 6],
//                                                        maximumTime: 8)
//        let orientation = PNIAnimatedValue<simd_quatf>(keyFrames: [simd_quatf(angle: Float(90).radians, axis: [0, 1, 0]),
//                                                                   simd_quatf(angle: Float(90).radians, axis: [0, 1, 0]),
//                                                                   simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0]),
//                                                                   simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0]),
//                                                                   simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])],
//                                                       times: [0, 2, 2.1, 4, 4.1], maximumTime: 8)
//        return PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(translation),
//                                         rotation: PNAnyAnimatedValue(orientation),
//                                         scale: PNAnyAnimatedValue(PNIAnimatedValue.static(from: [scale, scale, scale])))
//    }
//    private func buildEngineForDrummerScene() {
//        guard let device = metalView.device else {
//            fatalError("Could not initialize the scene")
//        }
//        let loader = PNISceneLoader(device: device,
//                                    assetLoader: PNIAssetLoader(),
//                                    translator: PNISceneTranslator(device: device))
//        guard var scene = loader.resource(name: "Bishop",
//                                          extension: "obj",
//                                          bundle: Bundle.main) else {
//            fatalError("Could not initialize the scene")
//        }
////        let plane = toyBiplane(loader: loader)
////        let ball = soccerBall(loader: loader)
////        let drummer = toyDrummer(loader: loader)
//        engine.scene.rootNode.add(child: scene.rootNode)
////        engine.scene.rootNode.add(children: [plane, ball, drummer])
////        engine.scene.environmentMap = loadEnvironmentMap()
//        addCamera(scene: engine.scene, position: [0, 2, -1])
//        addSpotLight(scene: engine.scene, intensity: 1, color: [1, 0, 0], coneAngle: Float(90).radians, position: [-1, 1, 0], castsShadows: false)
////        addSpotLight(scene: engine.scene, intensity: 1, color: [0, 1, 0], coneAngle: Float(90).radians, position: [-2, 1, 1], castsShadows: false)
////        addSpotLight(scene: engine.scene, intensity: 1, color: [0, 0, 1], coneAngle: Float(90).radians, position: [0, 1, 2], castsShadows: false)
////        addSpotLight(scene: engine.scene, intensity: 1, color: [1, 1, 0], coneAngle: Float(90).radians, position: [-2, 1, -1], castsShadows: false)
////        addSpotLight(scene: engine.scene, intensity: 1, color: [0, 1, 1], coneAngle: Float(90).radians, position: [-1, 1, -2], castsShadows: false)
////        addDirectionalLight(scene: engine.scene, intensity: 1, color: [0, 0, 1], direction: simd_float3(0, -1, 0).normalized, castsShadows: true)
////        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 0, 0], direction: simd_float3(0, -1, -0.1).normalized, castsShadows: true)
////        addDirectionalLight(scene: engine.scene, intensity: 4, color: [1, 0, 1], direction: simd_float3(0.2, -1, -0.1).normalized, castsShadows: true)
////        for i in 0...4 {
////            addOmniLight(scene: engine.scene, intensity: 4, color: [1, 0, 0], position: [0, 8, -1], castsShadows: false)
////            addOmniLight(scene: engine.scene, intensity: 3, color: [0, 0, 1], position: [0, 8, 0], castsShadows: false)
////            addOmniLight(scene: engine.scene, intensity: 2, color: [0, 1, 0], position: [0, 8, 1], castsShadows: false)
////        }
//        addAmbientLight(scene: engine.scene,
//                        intensity: 0.2,
//                        color: simd_float3(1, 1, 1),
//                        position: [0, 0, 0])
//    }

    private func listenForKeyboardEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return nil
        }
    }
    private func createScene() {
        guard let device = engineView.device else {
            fatalError("Could not initialize the scene")
        }
        let loader = PNISceneLoader(device: device,
                                    assetLoader: PNIAssetLoader(),
                                    translator: PNISceneTranslator(device: device))
        
        guard let bishop = loader.resource(name: "Bishop",
                                           extension: "obj",
                                           bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let knight = loader.resource(name: "Knight",
                                           extension: "obj",
                                           bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let rook = loader.resource(name: "Rook",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let board = loader.resource(name: "Board",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let queen = loader.resource(name: "Queen",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let king = loader.resource(name: "King",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let cubeMahogany = loader.resource(name: "Cube",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        guard let cubeSapele = loader.resource(name: "Cube",
                                         extension: "obj",
                                         bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
//        addAmbientLight(scene: engine.scene,
//                        intensity: 0.2,
//                        color: simd_float3(1, 1, 1),
//                        position: [0, 0, 0])
        cameraNode = addCamera(scene: engine.scene, position: [0, 2, -1])
        let textureLoader = MTKTextureLoader(device: engineView.device!)
        let sapeleTexture = try! textureLoader.newTexture(name: "sapele",
                                                    scaleFactor: 1,
                                                    bundle: Bundle.main,
                                                    options: nil)
        let mahoganyTexture = try! textureLoader.newTexture(name: "mahogany",
                                                    scaleFactor: 1,
                                                    bundle: Bundle.main,
                                                    options: nil)
        
        let sapeleMaterial = PNIMaterial(name: "sapele",
                                   albedo: sapeleTexture,
                                   roughness: sapeleTexture,
                                   normals: sapeleTexture,
                                   metallic: sapeleTexture)
        let mahoganyMaterial = PNIMaterial(name: "mahogany",
                                   albedo: mahoganyTexture,
                                   roughness: mahoganyTexture,
                                   normals: mahoganyTexture,
                                   metallic: mahoganyTexture)
        if let meshNode = (cubeSapele.children[0].data as? PNIMeshNode) {
            for d in meshNode.mesh.pieceDescriptions.count.naturalExclusive {
                meshNode.mesh.pieceDescriptions[d].material = sapeleMaterial
            }
        }
        if let meshNode = (cubeMahogany.children[0].data as? PNIMeshNode) {
            for d in meshNode.mesh.pieceDescriptions.count.naturalExclusive {
                meshNode.mesh.pieceDescriptions[d].material = mahoganyMaterial
            }
        }
        
        
        let scaleNode = PNNode(data: PNISceneNode(transform: .compose(translation: [0, 1.9, 3.5], rotation: .init(), scale: [0.17, 0.2, 0.17])) as PNSceneNode)
        scaleNode.add(child: board)
        let rookTransform = PNNode(data: PNISceneNode(transform: .compose(translation: [-3.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        rookTransform.add(child: rook)
        let knightTransform = PNNode(data: PNISceneNode(transform: .compose(translation: [-2.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        knightTransform.add(child: knight)
        let bishopTransform = PNNode(data: PNISceneNode(transform: .compose(translation: [-1.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        bishopTransform.add(child: bishop)
        let queenTransform = PNNode(data: PNISceneNode(transform: .compose(translation: [-0.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        queenTransform.add(child: queen)
        let kingTransform = PNNode(data: PNISceneNode(transform: .compose(translation: [0.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        kingTransform.add(child: king)
        let bishopTransform2 = PNNode(data: PNISceneNode(transform: .compose(translation: [1.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        bishopTransform2.add(child: bishop)
        let knightTransform2 = PNNode(data: PNISceneNode(transform: .compose(translation: [2.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        knightTransform2.add(child: knight)
        let rookTransform2 = PNNode(data: PNISceneNode(transform: .compose(translation: [3.5, 2, 0], rotation: .init(), scale: [0.2, 0.2, 0.2])) as PNSceneNode)
        rookTransform2.add(child: rook)
        let whites = PNNode(data: PNISceneNode(transform: .compose(translation: .zero, rotation: .init(), scale: [1, 1, 1])) as PNSceneNode)
        whites.add(children: rookTransform, knightTransform, bishopTransform, queenTransform, kingTransform, bishopTransform2, knightTransform2, rookTransform2)
        let black = PNNode(data: PNISceneNode(transform: .compose(translation: [0, 0, 7], rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]), scale: .one)) as PNSceneNode)
        black.add(children: rookTransform, knightTransform, bishopTransform, queenTransform, kingTransform, bishopTransform2, knightTransform2, rookTransform2)
        let fields = PNNode(data: PNISceneNode(transform: .compose(translation: [-3.5, 2.5, 0], rotation: .init(), scale: [1, 1, 1])) as PNSceneNode)
        for i in 0 ..< 8 {
            for j in 0 ..< 8 {
                let cubeNode = PNNode(data: PNISceneNode(transform: .compose(translation: [Float(i), -2, Float(j)], rotation: .init(), scale: [0.5, 0.5, 0.5])) as PNSceneNode)
                let isWhite = ((i + j) % 2) == 0
                cubeNode.add(child: isWhite ? cubeSapele : cubeMahogany)
                fields.add(child: cubeNode)
            }
        }
//        guard let meshNode = (board.children[0].data as? PNIMeshNode) else {
//            fatalError()
//        }
//        for i in meshNode.mesh.pieceDescriptions.count.naturalExclusive {
//            meshNode.mesh.pieceDescriptions[i].material = material
//        }
//        scaleNode.add(child: board)
//        addDirectionalLight(scene: engine.scene, intensity: 30, color: [1, 1, 1], direction: simd_float3(0, -1, 0).normalized, castsShadows: true)
//        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(0, -1, 0).normalized, castsShadows: true)
//        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(0, -1, 0).normalized, castsShadows: true)
        let all = PNNode(data: PNISceneNode(transform: .compose(translation: [0, 0, 0],
                                                                rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]),
                                                                scale: [0.5, 0.5, 0.5])) as PNSceneNode)
        all.add(children: whites, black, scaleNode, fields)
        engine.scene.rootNode.add(child: all)
        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(0, 1, -0.1).normalized, castsShadows: false)
        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(0, -1, 0.1).normalized, castsShadows: false)
//        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(-0.1, 1, 0).normalized, castsShadows: false)
//        addDirectionalLight(scene: engine.scene, intensity: 3, color: [1, 1, 1], direction: simd_float3(0.1, 1, 0).normalized, castsShadows: false)
    }
}
