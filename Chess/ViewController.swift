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
    
    private var cameraNode: PNCameraNode?
    private var selectedPiece: PNScenePiece?
    override func viewDidLoad() {
        super.viewDidLoad()
        engineView = view as? PNView
        engine = engineView.engine
        listenForKeyboardEvents()
        engine.scene = SceneBuilder(device: engineView.device!).build()
    }
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "f":
            view.window?.toggleFullScreen(self)
        case "a":
            fallthrough
        case "d":
            let minus = event.charactersIgnoringModifiers == "a"
            let nodeInteractor = PNINodeInteractor()
            nodeInteractor.forEach(node: engine.scene.rootNode, { node in
                guard let node = node.data as? PNAnimatedCameraNode else {
                    return
                }
                CameraController().rotate(camera: node, angleDegress: minus ? -45 : 45)
            })
        default:
            break
        }
    }
    private func listenForKeyboardEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return nil
        }
    }
    override func mouseDown(with event: NSEvent) {
        let manipulator = SceneManipulator()
        manipulator.performMoves(scene: engine.scene, moves: [
            Move(who: Piece(color: .white, type: .pawn(0)),
                 from: (1, 0),
                 to: (2, 0))
        ])
    }
}
