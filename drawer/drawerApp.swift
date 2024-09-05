import SwiftUI
import AppKit

class CustomPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        self.isMovable = false
        self.hidesOnDeactivate = false
        self.ignoresMouseEvents = true
    }
    
    override func makeKey() {}
    override func makeKeyAndOrderFront(_ sender: Any?) {}
    override func becomeKey() {}
    override func becomeMain() {}
}

@main
struct drawerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: CustomPanel?
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let arguments = CommandLine.arguments
        var message = "No message provided"
        var icon = "slash.circle.fill" // Default icon

        // Parse arguments
        for i in 1..<arguments.count {
            if arguments[i] == "--message" && i + 1 < arguments.count {
                message = arguments[i + 1]
            } else if arguments[i] == "--icon" && i + 1 < arguments.count {
                icon = arguments[i + 1]
            }
        }

        setupPanel(with: message, icon: icon)
    }
    
    func setupPanel(with message: String, icon: String) {
        let cornerRadius: CGFloat = 16
        let xOffset: CGFloat = 15
        let yOffset: CGFloat = 15
        
        let contentView = NSHostingView(rootView: ContentView(message: message, icon: icon, onClose: closePanel))
        contentView.frame.size = CGSize(width: 350, height: 0)
        
        let panel = CustomPanel(
            contentRect: NSRect(origin: .zero, size: contentView.frame.size),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = cornerRadius
        contentView.layer?.masksToBounds = true
        
        panel.contentView = contentView
        
        // Position the panel
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let finalOrigin = NSPoint(
                x: screenFrame.maxX - contentView.frame.width - xOffset,
                y: screenFrame.maxY - contentView.frame.height - yOffset
            )
            panel.setFrameOrigin(finalOrigin)
        }
        
        panel.orderFrontRegardless()
        self.panel = panel
        
        // Set up a timer to close the panel after 2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.closePanel()
        }
    }
    
    func closePanel() {
        self.panel?.close()
        self.panel = nil
        self.timer?.invalidate()
        self.timer = nil
        NSApp.terminate(nil)
    }
}
