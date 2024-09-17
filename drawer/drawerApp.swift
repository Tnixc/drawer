import SwiftUI
import AppKit

@main
struct DrawerApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var dismissTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow(message: "Time to clock out")
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.dismissWindow()
        }
    }

    func setupWindow(message: String) {
        let contentView = NSHostingView(rootView: ContentView(message: message))

        let window = NSWindow(
            contentRect: NSScreen.main!.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentView = contentView
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.level = .statusBar
        window.ignoresMouseEvents = false
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]

        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
    
    func dismissWindow() {
        window?.close()
        NSApp.terminate(nil)
    }
}
