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
    private var state = GameState.initial
    override func viewDidLoad() {
        super.viewDidLoad()
        engineView = view as? PNView
        engine = engineView.engine
        listenForKeyboardEvents()
        guard let device = engineView.device else {
            fatalError("Device not set")
        }
        engine.scene = SceneBuilder(device: device).build(board: state.board)
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
        let camera = engine.scene.rootNode.all().compactMap({
            $0.data as? PNAnimatedCameraNode
        }).first
        guard let camera = camera, let frame = view.window?.frame else {
            return
        }
        let handler = MouseInteractionHandler(interactor: engineView.interactor)
        var moves = [Move]()
        let selected = state.selectedPiece
        if state.expectation == .piecePick {
            let piece = handler.pickPiece(event: event,
                                          camera: camera,
                                          scene: engine.scene,
                                          viewframe: frame)
            let pieceS = Piece(literal: piece?.data.name ?? "")
            print(pieceS)
            let result = game.select(piece: pieceS, state: state)
            moves = result.moves
            state = result.newState
        } else {
            let field = handler.pickField(event: event,
                                          camera: camera,
                                          scene: engine.scene,
                                          viewframe: frame)
            let fieldS = Field(literal: field?.data.name ?? "")
            print(fieldS)
            let result = game.select(field: fieldS, state: state)
            moves = result.moves
            state = result.newState
        }
        print(moves)
        let manipulator = SceneManipulator()
        let selectedAfter = state.selectedPiece
        if selectedAfter != selected {
            if let selected = selected {
                manipulator.deselect(scene: engine.scene, piece: selected)
            }
            if let selectedAfter = selectedAfter {
                manipulator.select(scene: engine.scene, piece: selectedAfter)
            }
        }
        manipulator.performMoves(scene: engine.scene, moves: moves)
    }
}
