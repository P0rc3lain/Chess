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
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.title == "Save" {
            return NSApp.windows.contains(where: { $0.isVisible })
        }
        return true
    }
    
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
        _ = SaveCoordinator.shared.wipe()
    }
    @IBAction func createGame(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialController()
        let windowController = (controller as! NSWindowController)
        windowController.showWindow(self)        
    }
    @objc
    func loadGame(sender: NSMenuItem) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialController()
        let windowController = (controller as! NSWindowController)
        windowController.showWindow(self)
        let game = windowController.contentViewController as? GameViewController
        guard let gameSave = SaveCoordinator.shared.load(index: sender.tag) else {
            fatalError("Index out of bounds")
        }
        game?.load(save: gameSave)
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
