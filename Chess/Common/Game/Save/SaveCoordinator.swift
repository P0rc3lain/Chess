//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine
import SwiftData

class SaveCoordinator {
    let saveDidChange = PassthroughSubject<Void, Never>()
    private let container: ModelContainer
    static let shared: SaveCoordinator = {
        SaveCoordinator()
    }()
    private init() {
        do {
            container = try ModelContainer(for: SaveGame.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    func save(game: SaveGame) -> Bool {
        let context = ModelContext(container)
        save(state: game.state, context: context)
        context.insert(game)
        do {
            try context.save()
        } catch {
            print("Failed to insert: \(error)")
            return false
        }
        saveDidChange.send()
        return true
    }
    private func save(state: GameState, context: ModelContext) {
        context.insert(state)
        if let previous = state.previous {
            save(state: previous, context: context)
        }
    }
    var saveCount: Int {
        all.count
    }
    var all: [SaveGame] {
        let context = ModelContext(container)

        let fetchDescriptor = FetchDescriptor<SaveGame>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            return []
        }
    }
    func load(index: Int) -> SaveGame? {
        let context = ModelContext(container)

        let fetchDescriptor = FetchDescriptor<SaveGame>()
        do {
            return try context.fetch(fetchDescriptor)[index]
        } catch {
            return nil
        }
    }
    func wipe() -> Bool {
        let context = ModelContext(container)

        let fetchDescriptor = FetchDescriptor<SaveGame>()
        do {
            let saves = try context.fetch(fetchDescriptor)

            for save in saves {
                context.delete(save)
            }

            try context.save()
            print("All save records deleted!")
        } catch {
            print("Failed to delete: \(error)")
            return false
        }
        saveDidChange.send()
        return true
    }
}
