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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPanel()
    }
    
    func setupPanel() {
        let cornerRadius: CGFloat = 16
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 10
        
        // Create a temporary off-screen view to measure content size
        let measureView = NSHostingView(rootView: ContentView(onClose: closePanel))
        measureView.frame.size = CGSize(width: 9999, height: 9999)
        measureView.layout()
        let contentSize = measureView.fittingSize
        
        // Create the actual content view with the correct size
        let contentView = NSHostingView(rootView: ContentView(onClose: closePanel))
        contentView.frame.size = contentSize
        
        let panel = CustomPanel(
            contentRect: NSRect(origin: .zero, size: contentSize),
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
                x: screenFrame.maxX - contentSize.width - xOffset,
                y: screenFrame.maxY - contentSize.height - yOffset
            )
            panel.setFrameOrigin(finalOrigin)
        }
        
        panel.orderFrontRegardless()
        self.panel = panel
    }
    
    func closePanel() {
        self.panel?.close()
        self.panel = nil
    }
}
