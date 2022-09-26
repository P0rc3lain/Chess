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

class GameViewController: NSViewController, GameDelegate {
    @IBOutlet weak var info: NSTextField!
    private var engine: PNEngine!
    private var engineView: PNView!
    private var interactionHandler: MouseInteractionHandler!
    private let game = Game()
    private let nodeInteractor = PNINodeInteractor()
    private let cameraController = CameraController()
    private let manipulator = SceneManipulator()
    private var state = GameState.initial
    override func viewDidLoad() {
        super.viewDidLoad()
        info.alphaValue = 0
        engineView = view.subviews[0] as? PNView
        engine = engineView.engine
        interactionHandler = MouseInteractionHandler(interactor: engineView.interactor)
        listenForKeyboardEvents()
        game.delegate = self
        guard let device = engineView.device else {
            fatalError("Device not set")
        }
        let builder = SceneBuilder(device: device)
        engine.scene = builder.build(board: state.board)
    }
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "f":
            view.window?.toggleFullScreen(self)
        case "d", "a":
            let minus = event.charactersIgnoringModifiers == "a"
            nodeInteractor.forEach(node: engine.scene.rootNode, { node in
                guard let node = node.data as? PNAnimatedCameraNode else {
                    return
                }
                cameraController.rotate(camera: node, angleDegress: minus ? -45 : 45)
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
        guard let camera = camera else {
            return
        }
        let frame = view.frame
        var moves = [Move]()
        let selected = state.selectedPiece
        if state.expectation == .piecePick {
            let piece = interactionHandler.pickPiece(event: event,
                                                     camera: camera,
                                                     scene: engine.scene,
                                                     viewframe: frame)
            let pieceS = Piece(literal: piece?.data.name ?? "")
            let result = game.select(piece: pieceS, state: state)
            moves = result.moves
            state = result.newState
        } else {
            let field = interactionHandler.pickField(event: event,
                                                     camera: camera,
                                                     scene: engine.scene,
                                                     viewframe: frame)
            
            let fieldS = FieldParser().create(literal: field?.data.name ?? "")
            let result = game.select(field: fieldS, state: state)
            moves = result.moves
            state = result.newState
        }
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
    func check(attacker: PieceColor) {
        updateText("Check")
    }
    func stalemate(attacker: PieceColor) {
        updateText("Stalemate")
    }
    func checkmate(attacker: PieceColor) {
        updateText("Checkmate")
    }
    func updateText(_ value: String) {
        if value.isEmpty && info.alphaValue > 0 {
            info.stringValue = ""
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 2
                info.animator().alphaValue = 0
            }, completionHandler: { })
        } else if !value.isEmpty && info.alphaValue == 0 {
            info.stringValue = value
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 2
                info.animator().alphaValue = 1
            }, completionHandler: { })
        }
    }
}
