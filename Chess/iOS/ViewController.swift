//
//  Created by Mateusz Stompór on 21/10/2022.
//

import UIKit
import Engine

class ViewController: UIViewController, GameDelegate {
    private var engine: PNEngine!
    private var engineView: PNView!
    private var interactionHandler: MouseInteractionHandler!
    private let game = Game()
    private let nodeInteractor = PNINodeInteractor()
    private let cameraController = CameraController()
    private var manipulator: SceneManipulator!
    private var state = GameState.initial
    override func viewDidLoad() {
        super.viewDidLoad()
        engineView = view as? PNView
        engine = engineView.engine
        interactionHandler = MouseInteractionHandler(interactor: engineView.interactor)
        listenForEvents()
        game.delegate = self
        guard let device = engineView.device else {
            fatalError("Device not set")
        }
        let builder = SceneBuilder(device: device)
        manipulator = SceneManipulator(device: device)
        engine.scene = builder.build(board: state.board)
    }
    func listenForEvents() {
        let tap = UITapGestureRecognizer(target: self,
                                       action: #selector(self.handleTap(_:)))
        engineView.addGestureRecognizer(tap)
    }
    func chooseAction(action: [Action]) -> Action {
        return action[0]
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
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
        let location = CGPoint(x: sender!.location(in: view).x,
                              y: view.frame.height-sender!.location(in: view).y)
        if state.expectation == .piece {
            let piece = interactionHandler.pickPiece(location: location,
                                                     camera: camera,
                                                     scene: engine.scene,
                                                     viewframe: frame.size)
            let pieceS = PieceParser().create(literal: piece?.data.name ?? "")
            let result = game.select(piece: pieceS, state: state)
            moves = result.moves
            state = result.newState
        } else {
            let field = interactionHandler.pickField(location: location,
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
    }
}

