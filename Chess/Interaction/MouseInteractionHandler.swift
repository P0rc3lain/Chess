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
    init(interactor: PNScreenInteractor) {
        self.interactor = interactor
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
        return allFound.first(where: {
            guard $0.data as? PNMeshNode != nil else {
                return false
            }
            return $0.parent?.parent?.data.name.count ?? 0 > 2
        })
    }
    func pickField(event: NSEvent,
                   camera: PNCameraNode,
                   scene: PNScene,
                   viewframe frame: NSRect) -> PNScenePiece? {
        let allFound = click(event: event, camera: camera, scene: scene, viewframe: frame)
        return allFound.first(where: {
            guard $0.data as? PNMeshNode != nil else {
                return false
            }
            return $0.parent?.parent?.data.name.count ?? 0 == 2
        })
    }
}
