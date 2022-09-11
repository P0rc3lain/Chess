//
//  Loader.swift
//  Chess
//
//  Created by Mateusz Stompór on 06/09/2022.
//

import MetalKit
import Engine

class ResourceLoader {
    private let textureLoader: MTKTextureLoader
    private let interactor: PNNodeInteractor
    private let sceneLoader: PNSceneLoader
    private let device: MTLDevice
    init(device: MTLDevice) {
        self.interactor = PNINodeInteractor()
        self.textureLoader = MTKTextureLoader(device: device)
        self.sceneLoader = PNISceneLoader.default(device: device)
        self.device = device
    }
    func loadMaterial(textureName name: String) -> PNMaterial {
        guard let texture = try? textureLoader.newTexture(name: name,
                                                          scaleFactor: 1,
                                                          bundle: Bundle.main,
                                                          options: [MTKTextureLoader.Option.SRGB: false]),
              let blackTexture = device.makeTextureSolid2D(color: [0, 0, 0, 1]),
              let normalsTexture = device.makeTextureSolid2D(color: .defaultNormalsColor) else {
            fatalError("Could not load material")
        }
        return PNIMaterial(name: name,
                           albedo: texture,
                           roughness: blackTexture,
                           normals: normalsTexture,
                           metallic: blackTexture)
    }
    func loadObject(name: String, material: PNMaterial) -> PNScenePiece {
        let object = loadObject(name: name)
        set(material: material, node: object)
        return object
    }
    private func loadObject(name: String) -> PNScenePiece {
        guard let model = sceneLoader.resource(name: name,
                                               extension: "obj",
                                               bundle: Bundle.main)?.rootNode else {
            fatalError("Could not initialize the scene")
        }
        return model
    }
    private func set(material: PNMaterial, node: PNScenePiece) {
        interactor.forEach(node: node) { n in
            guard let meshNode = n.data as? PNIMeshNode else {
                return
            }
            for index in meshNode.mesh.pieceDescriptions.count.exclusiveON {
                meshNode.mesh.pieceDescriptions[index].material = material
            }
        }
    }
}
