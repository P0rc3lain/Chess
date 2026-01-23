//
//  Copyright © 2020 Mateusz Stompór. All rights reserved.
//

import Cocoa
import Combine
import Engine
import ModelIO
import MetalKit
import PNShared

class GameViewController: NSViewController, GameDelegate, NSGestureRecognizerDelegate {
    @IBOutlet private weak var info: NSTextField!
    private var engine: PNEngine!
    private var engineView: PNView!
    private var interactionHandler: MouseInteractionHandler!
    private let game = Game()
    private var cancellables = Set<AnyCancellable>()
    private let nodeInteractor = PNINodeInteractor()
    private let cameraController = CameraController()
    private var manipulator: SceneManipulator!
    private var state = GameState.initial
    private var last: NSPoint = .zero
    private func setupNotifications() {
        NotificationCenter.default.publisher(for: .persistanceSave)
        .sink { [weak self] notification in
            guard let self else { return }
            if self.view.window?.isKeyWindow ?? false {
                let saveState = SaveGame(creationDate: .now, state: state)
                _ = SaveCoordinator.shared.save(game: saveState)
            }
        }
        .store(in: &cancellables)
    }
    func load(save gameSave: SaveGame) {
        guard let device = engineView.device else {
            fatalError("Device not set")
        }
        let builder = SceneBuilder(device: device)
        engine.scene = builder.build(board: gameSave.state.board)
    }
    
    func rotateArcball(from start: SIMD3<Float>,
                       to end: SIMD3<Float>) -> simd_quatf {
        let axis = cross(start, end)
        let dotp = max(min(dot(start, end), 1.0), -1.0) // clamp to avoid NaN
        let angle = acos(dotp)
        
        return simd_quatf(angle: angle, axis: normalize(axis))
    }
    func mapToSphere(nx: Float, ny: Float) -> simd_float3 {
        let len2 = nx*nx + ny*ny
        if len2 <= 1.0 {
            return normalize(SIMD3(nx, ny, sqrt(1.0 - len2)))
        } else {
            return normalize(SIMD3(nx, ny, 0))
        }
    }
    @objc
    func handlePan(recognizer: NSPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let tNormalized = NSPoint(x: translation.x / view.bounds.width,
                                  y: translation.y / view.bounds.height)
        if recognizer.state == .began {
            last = tNormalized
        }
        let start = mapToSphere(nx: Float(last.x), ny: Float(last.y))
        let end = mapToSphere(nx: Float(tNormalized.x), ny: Float(tNormalized.y))
        let distance = length(end - start)
        if (distance < 1e-3) {
            return
        }
        nodeInteractor.forEach(node: engine.scene.rootNode, { node in
            guard let node = node.data as? PNAnimatedCameraNode else {
                return
            }
            let arc = rotateArcball(from: end, to: start)
            cameraController.rotate(camera: node, quatf: arc)
        })
        last = tNormalized
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = NSPanGestureRecognizer(target: self,
                                                          action: #selector(handlePan(recognizer: )))
        panGestureRecognizer.allowedTouchTypes = [.direct]
        view.addGestureRecognizer(panGestureRecognizer)
        
        setupNotifications()
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
        manipulator = SceneManipulator(device: device)
        engine.scene = builder.build(board: state.board)
    }
    func down(with event: NSEvent) -> Bool {
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
        case "r":
            let rotation = simd_quatf(angle: Float(45).radians, axis: [0, 1, 0]) *
                           simd_quatf(angle: Float(45).radians, axis: [-1, 0, 0])
            let translation = simd_float4x4.translation(vector: [0, 0.41, 5])
            nodeInteractor.forEach(node: engine.scene.rootNode, { node in
                guard let node = node.data as? PNAnimatedCameraNode else {
                    return
                }
                cameraController.set(camera: node, transformation: translation * rotation.rotationMatrix)
            })
        default:
            return false
        }
        return true
    }
    private func listenForKeyboardEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            guard self?.view.window?.isKeyWindow ?? false else {
                return $0
            }
            return (self?.down(with: $0) ?? false) ? nil : $0
        }
    }
    override func mouseDown(with event: NSEvent) {
        guard state.checkState != .stalemate && state.checkState != .checkmate else {
            return
        }
        let camera = engine.scene.rootNode.all().compactMap({
            $0.data as? PNAnimatedCameraNode
        }).first
        guard let camera = camera else {
            return
        }
        let frame = view.frame
        var moves = [Move]()
        let selected = state.selectedPiece
        if state.expectation == .piece {
            let piece = interactionHandler.pickPiece(location: event.locationInWindow,
                                                     camera: camera,
                                                     scene: engine.scene,
                                                     viewframe: frame.size)
            let pieceS = PieceParser().create(literal: piece?.data.name ?? "")
            let result = game.select(piece: pieceS, state: state)
            moves = result.moves
            state = result.newState
        } else {
            let field = interactionHandler.pickField(location: event.locationInWindow,
                                                     camera: camera,
                                                     scene: engine.scene,
                                                     viewframe: frame.size)
            
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
        switch state.checkState {
        case .check:
            updateText("Check")
        case .checkmate:
            updateText("Checkmate")
        case .stalemate:
            updateText("Stalemate")
        default:
            updateText("")
        }
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
    func chooseAction(action: [Action]) -> Action {
        let alert = NSAlert()
        alert.messageText = "Promotion required"
        alert.informativeText = "Select type that the pawn is going to be exchanged for"
        for a in action {
            alert.addButton(withTitle:a.piecesToAdd[0].piece.type.coreType.rawValue)
        }
        return action[alert.runModal().rawValue - 1000]
    }
}
