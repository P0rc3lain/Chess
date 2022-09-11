//
//  ViewController.swift
//  Chess
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
    private let game = Game()
    private var cameraNode: PNCameraNode?
    private var selectedPiece: PNScenePiece?
    override func viewDidLoad() {
        super.viewDidLoad()
        engineView = view as? PNView
        engine = engineView.engine
        listenForKeyboardEvents()
        engine.scene = SceneBuilder(device: engineView.device!).build(board: game.board)
    }
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "f":
            view.window?.toggleFullScreen(self)
        case "d", "a":
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
        let camera = engine.scene.rootNode.findNode(where: { node in (node.data as? PNAnimatedCameraNode) != nil })
        guard let camera = camera?.data as? PNAnimatedCameraNode, let frame = view.window?.frame else {
            return
        }
        let handler = MouseInteractionHandler(interactor: engineView.interactor)
        var moves = [Move]()
        if game.currentExpectation == .piecePick {
            let piece = handler.pickPiece(event: event,
                                          camera: camera,
                                          scene: engine.scene,
                                          viewframe: frame)
            let pieceS = Piece(literal: piece?.data.name ?? "")
            print(pieceS)
            moves = game.selectPiece(piece: pieceS)
        } else {
            let field = handler.pickField(event: event,
                                          camera: camera,
                                          scene: engine.scene,
                                          viewframe: frame)
            
            let fieldS = Field(literal: field?.data.name ?? "")
            print(fieldS)
            moves = game.selectField(field: fieldS)
        }
        print(moves)
        let manipulator = SceneManipulator()
        manipulator.performMoves(scene: engine.scene, moves: moves)
    }
}
