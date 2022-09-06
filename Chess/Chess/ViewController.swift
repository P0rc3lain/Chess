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
        let translation = PNIAnimatedValue<simd_float3>(keyFrames: [[0, 3, -10],
                                                                    [0, 3, -10],
                                                                    [0, 3, -10],
                                                                    [0, 3, -10],
                                                                    [0, 3, -10]],
                                                        times: [0, 2, 4, 6, 8],
                                                        maximumTime: 10)
        let orientation = PNIAnimatedValue<simd_quatf>(keyFrames: [simd_quatf(angle: Float(90).radians, axis: [0, 3.5, 0]),
                                                                   simd_quatf(angle: Float(-90).radians, axis: [0, 3.5, 0]),
                                                                   simd_quatf(angle: Float(-180).radians, axis: [0, 3.5, 0]),
                                                                   simd_quatf(angle: Float(-270).radians, axis: [0, 3.5, 0])],
                                                       times: [0, 3, 6, 8], maximumTime: 10)
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
        let treeNode = PNScenePiece.make(data: node, parent: scene.rootNode)
        scene.rootNode.children.append(treeNode)
        return node
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
    private func listenForKeyboardEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return nil
        }
    }
    private func loadObject(loader: PNSceneLoader, name: String) -> PNScenePiece {
        guard let model = loader.resource(name: name,
                                          extension: "obj",
                                          bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        return model
    }
    private func set(material: PNMaterial, node: PNScenePiece) {
        PNINodeInteractor().forEach(node: node) { n in
            guard let meshNode = n.data as? PNIMeshNode else {
                return
            }
            for index in meshNode.mesh.pieceDescriptions.count.exclusiveON {
                meshNode.mesh.pieceDescriptions[index].material = material
            }
        }
    }
    private func load(loader: PNSceneLoader, name: String, material: PNMaterial) -> PNScenePiece {
        let object = loadObject(loader: loader, name: name)
        set(material: material, node: object)
        return object
    }
    private func loadPieces(loader: PNSceneLoader, material: PNMaterial) -> [[PNScenePiece]] {
        let bishop = load(loader: loader, name: "Bishop", material: material)
        let knight = load(loader: loader, name: "Knight", material: material)
        let rook = load(loader: loader, name: "Rook", material: material)
        let queen = load(loader: loader, name: "Queen", material: material)
        let king = load(loader: loader, name: "King", material: material)
        let pawn = load(loader: loader, name: "Pawn", material: material)
        var nodes = [
            [load(loader: loader, name: "Rook", material: material),
             load(loader: loader, name: "Knight", material: material),
             load(loader: loader, name: "Bishop", material: material),
             king,
             queen,
             load(loader: loader, name: "Bishop", material: material),
             load(loader: loader, name: "Knight", material: material),
             load(loader: loader, name: "Rook", material: material)],
            [load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material),
             load(loader: loader, name: "Pawn", material: material)]
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
    private func loadBoardFields(loader: PNSceneLoader, mahogany: PNMaterial, sapele: PNMaterial) -> PNNode<PNSceneNode> {
        
        let fields = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [-3.5, 2.5, 0],
                                                                              scale: [1, 1, 1])))
        for i in 0 ..< 8 {
            for j in 0 ..< 8 {
                let cubeNode = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [Float(i), -1.6, Float(j)],
                                                                                        scale: [0.5, 0.1, 0.5])))
                let isWhite = ((i + j) % 2) == 0
                let cubeMahogany = load(loader: loader, name: "Cube", material: mahogany)
                let cubeSapele = load(loader: loader, name: "Cube", material: sapele)
                cubeNode.add(child: isWhite ? cubeSapele : cubeMahogany)
                fields.add(child: cubeNode)
            }
        }
        return fields
    }
    private func loadMaterial(loader: MTKTextureLoader, textureName name: String) -> PNMaterial {
        guard let texture = try? loader.newTexture(name: name,
                                                   scaleFactor: 1,
                                                   bundle: Bundle.main,
                                                   options: nil) else {
            fatalError("Could not load material")
        }
        return PNIMaterial(name: name,
                           albedo: texture,
                           roughness: texture,
                           normals: texture,
                           metallic: texture)
    }
    private func loadBoard(loader: PNSceneLoader, material: PNMaterial) -> PNNode<PNSceneNode> {
        let board = load(loader: loader, name: "Board", material: material)
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
    private func createScene() {
        guard let device = engineView.device else {
            fatalError("Could not initialize the scene")
        }
        let loader = PNISceneLoader(device: device,
                                    assetLoader: PNIAssetLoader(),
                                    translator: PNISceneTranslator(device: device))
        let textureLoader = MTKTextureLoader(device: device)
        let sapeleMaterial = loadMaterial(loader: textureLoader, textureName: "sapele")
        let mahoganyMaterial = loadMaterial(loader: textureLoader, textureName: "mahogany")
        addAmbientLight(scene: engine.scene,
                        intensity: 0.2,
                        color: simd_float3(1, 1, 1),
                        position: [0, 0, 0])
        cameraNode = addCamera(scene: engine.scene, position: [0, 2, -1])
        
        let board = loadBoard(loader: loader, material: sapeleMaterial)
        let whites = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: .zero,
                                                                              scale: [1, 1, 1])))
        for row in loadPieces(loader: loader, material: sapeleMaterial) {
            whites.add(children: row)
        }
        let black = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, 7],
                                                                             rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]),
                                                                             scale: .one)))
        var mahoganyPieces = loadPieces(loader: loader, material: mahoganyMaterial)
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
        
        let all = PNScenePiece.make(data: PNISceneNode(transform: .compose(translation: [0, 0, 0],
                                                                           rotation: .init(angle: Float(180).radians, axis: [0, 1, 0]),
                                                                           scale: [0.5, 0.5, 0.5])))
        let fields = loadBoardFields(loader: loader, mahogany: mahoganyMaterial, sapele: sapeleMaterial)
//        all.add(children: board)
        all.add(children: whites, black, board, fields)
//        addOmniLight(scene: engine.scene,
//                     intensity: 10,
//                     influenceRadius: 20,
//                     color: [1, 1, 1],
//                     position: [0, 2, 0],
//                     castsShadows: false)
        engine.scene.rootNode.add(child: all)
//        engine.scene.environmentMap = device.makeTextureSolidCube(color: [1, 1, 1, 1])!
        
        addDirectionalLight(scene: engine.scene,
                            intensity: 10,
                            color: [1, 1, 1],
                            direction: simd_float3(0, 1, 0).normalized,
                            castsShadows: false)
//        addDirectionalLight(scene: engine.scene,
//                            intensity: 10,
//                            color: [1, 1, 1],
//                            direction: simd_float3(0, -1, 0).normalized,
//                            castsShadows: false)
        updateTrackingAreas()
    }
//    override func mouseMoved(with event: NSEvent) {
//        <#code#>
//    }
    var trackingArea : NSTrackingArea?

    func updateTrackingAreas() {
//        if trackingArea != nil {
//            self.removeTrackingArea(trackingArea!)
//        }
        let options : NSTrackingArea.Options =
        [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect]
        trackingArea = NSTrackingArea(rect: self.view.bounds, options: options,
                                      owner: self, userInfo: nil)
        self.view.addTrackingArea(trackingArea!)
    }
    override func mouseMoved(with event: NSEvent) {
        guard let frame = view.window?.frame, let cam = cameraNode else {
            return
        }
        let location = event.locationInWindow
        let point = PNPoint2D(Float(location.x/frame.width * 2 - 1),
                              Float(location.y/frame.height * 2 - 1))
//        let inverseProjection = cameraNode!.camera.projectionMatrixInverse
//        let direction = inverseProjection * simd_float4(point.x, point.y, 1, 1)
//        let rayEye = PNRay(origin: .zero, direction: direction.xyz.normalized)
//        let rayWorld = cameraNode!.worldTransform.value * rayEye
//        print(rayWorld)
//        PNINodeInteractor().forEach(node: engine.scene.rootNode) { (node, level: Int?) in
//            let lvl = level ?? 0
//            if let bb = node.data.worldBoundingBox.value {
//                let itDoes = PNIBoundInteractor().intersect(PNIBoundingBoxInteractor.default.bound(bb), ray: rayWorld)
//                let offset = String(repeating: "\t", count: lvl)
//                print(offset + "\(PNIBoundingBoxInteractor.default.bound(bb)) " + "\(node.data.intrinsicBoundingBox != nil ? "🧦" : "")" + (itDoes ? "🍟" : ""))
//                return lvl + 1
//            } else {
//                return lvl + 1
//            }
//        }


//        print(point)
//
        let nodes = engineView.interactor.pick(camera: cameraNode!,
                                              scene: engine.scene,
                                              point: point)
//        print(nodes)
        nodes.forEach({
            if let camera = $0.data as? PNCameraNode {
            // nothing
            } else {
//                _ = $0.removeSubtree()
                if $0.children.isEmpty {
                    if let _ = $0.data as? PNMeshNode {
                        var cur = $0.data.transform.value
                        cur.translation.y += 1
                        $0.data.transform.send(cur)
                    }
                    if let _ = $0.data as? PNRiggedMesh {
                        _ = $0.removeSubtree()
                    }
                    if let _ = $0.data as? PNAnimatedRiggedMesh {
                        _ = $0.removeSubtree()
                    }
                    //                    if let _ = $0.data as? PNAnimatedMesh {
                    //                        _ = $0.removeSubtree()
                    //                    }
                }
            }
            
        })
    }
}
