import SwiftUI
import AppKit

class CustomPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
    }
}

@main
struct drawerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPanel()
    }
    
    func setupPanel() {
        let cornerRadius: CGFloat = 12
        let xOffset: CGFloat = 20
        let yOffset: CGFloat = 20
        
        // Create a temporary off-screen view to measure content size
        let measureView = NSHostingView(rootView: ContentView())
        measureView.frame.size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // Force layout to get accurate size
        measureView.layout()
        let contentSize = measureView.fittingSize
        
        // Create the actual content view with the correct size
        let contentView = NSHostingView(rootView: ContentView())
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
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.isMovable = false
        panel.hidesOnDeactivate = false
        
        // Position the panel
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            panel.setFrameOrigin(NSPoint(
                x: screenFrame.maxX - contentSize.width - xOffset,
                y: screenFrame.maxY - contentSize.height - yOffset
            ))
        }
        
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }
}
