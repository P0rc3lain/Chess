//
//  MouseInteractionHandler.swift
//  Chess
//
//  Created by Mateusz Stompór on 09/09/2022.
//

import Engine
import Cocoa

class MouseInteractionHandler {
    private let interactor: PNScreenInteractor
    private let bbInteractor: PNBoundingBoxInteractor
    private let bInteractor: PNBoundInteractor
    init(interactor: PNScreenInteractor) {
        self.interactor = interactor
        self.bbInteractor = PNIBoundingBoxInteractor.default
        self.bInteractor = PNIBoundInteractor()
    }
    func click(event: NSEvent,
               camera: PNCameraNode,
               scene: PNScene,
               viewframe frame: NSRect) -> [PNScenePiece] {
        let location = event.locationInWindow
        let point = PNPoint2D(Float(location.x/frame.width * 2 - 1),
                              Float(location.y/frame.height * 2 - 1))
        
        let allNodes = interactor.pick(camera: camera, scene: scene, point: point)
        return allNodes
    }
    func pickPiece(event: NSEvent,
                   camera: PNCameraNode,
                   scene: PNScene,
                   viewframe frame: NSRect) -> PNScenePiece? {
        let allFound = click(event: event, camera: camera, scene: scene, viewframe: frame)
        return allFound.compactMap({
            guard $0.data as? PNMeshNode != nil else {
                return nil
            }
            return $0.parent?.parent?.parent?.parent
        }).sorted(by: { first, second in
            guard let firstBB = first.data.worldBoundingBox.value,
                  let secondBB = second.data.worldBoundingBox.value,
                  let cameraBB = camera.worldBoundingBox.value else {
                return false
            }
            let cameraCenter = bInteractor.center(bbInteractor.bound(cameraBB))
            let centerFirst = bInteractor.center(bbInteractor.bound(firstBB))
            let centerSecond = bInteractor.center(bbInteractor.bound(secondBB))
            return (cameraCenter - centerFirst).norm > (cameraCenter - centerSecond).norm
        }).first(where: {
            $0.data.name.count > 2
        })
    }
    func pickField(event: NSEvent,
                   camera: PNCameraNode,
                   scene: PNScene,
                   viewframe frame: NSRect) -> PNScenePiece? {
        let allFound = click(event: event, camera: camera, scene: scene, viewframe: frame)
        return allFound.compactMap({
            guard $0.data as? PNMeshNode != nil else {
                return nil
            }
            return $0.parent?.parent
        }).first(where: {
            $0.data.name.count == 2
        })
    }
}
