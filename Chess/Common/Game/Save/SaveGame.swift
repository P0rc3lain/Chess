//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation
import SwiftData

@Model
class SaveGame {
    var creationDate: Date
    var state: GameState
    init(creationDate: Date, state: GameState) {
        self.creationDate = creationDate
        self.state = state
    }
}
