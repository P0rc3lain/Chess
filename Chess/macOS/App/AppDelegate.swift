//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Cocoa
import Combine

extension Notification.Name {
    static let persistanceDeleteAll = Notification.Name("persistanceDeleteAll")
    static let persistanceSave = Notification.Name("persistanceSave")
    static let persistanceLoad = Notification.Name("persistanceLoad")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var gameSavesSubscription: AnyCancellable?
    @IBOutlet private weak var historyClear: NSMenuItem!
    @IBOutlet private weak var separator: NSMenuItem!
    
    @IBOutlet private weak var savesMenu: NSMenu!
    @IBAction private func saveGame(_ sender: NSMenuItem) {
        NotificationCenter.default.post(
            name: .persistanceSave,
            object: nil
        )
    }
    @IBAction func deleteAll(_ sender: NSMenuItem) {
        NotificationCenter.default.post(
            name: .persistanceDeleteAll,
            object: nil
        )
    }
    @IBAction func createGame(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialController()
        (controller as! NSWindowController).showWindow(self)
    }
    @objc
    func loadGame(sender: NSMenuItem) {
        NotificationCenter.default.post(
            name: .persistanceLoad,
            object: ["index": sender.tag]
        )
    }
    private func updateItems() {
        let count = SaveCoordinator.shared.saveCount
        let items = (0 ..< count).map { i in
            let name = "Save #\(i)"
            let item = NSMenuItem(title: name,
                                  action: #selector(loadGame),
                                  keyEquivalent: "")
            item.tag = i
            return item
        }
        savesMenu.items = items + [separator, historyClear]
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateItems()
        gameSavesSubscription = SaveCoordinator.shared.saveDidChange.sink { [weak self] in
            self?.updateItems()
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
