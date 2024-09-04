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
    }
}
import SwiftUI
import AppKit

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
        let cornerRadius: CGFloat = 16
        let xOffset: CGFloat = 20
        let yOffset: CGFloat = 20
        
        // Create a temporary off-screen view to measure content size
        let measureView = NSHostingView(rootView: ContentView(onClose: closePanel))
        measureView.frame.size = CGSize(width: 9999, height: 9999)
        
        // Force layout to get accurate size
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
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.isMovable = false
        panel.hidesOnDeactivate = false
        panel.alphaValue = 0 // Start with zero opacity
        
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
        
        // Animate the panel appearance
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1
        }
    }
    
    func closePanel() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel?.animator().alphaValue = 0
        } completionHandler: {
            self.panel?.close()
            self.panel = nil
        }
    }
}
