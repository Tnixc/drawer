import SwiftUI
import AppKit

class CustomPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool, configuration: PanelConfiguration) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.invalidateShadow()
    }
}

struct PanelView: NSViewRepresentable {
    let contentView: NSView
    
    func makeNSView(context: Context) -> NSView {
        return contentView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
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
        let panelConfig = PanelConfiguration(
            width: 150,
            height: 70,
            cornerRadius: 20,
            xOffset: 20,
            yOffset: 20
        )
        
        let panel = CustomPanel(
            contentRect: NSRect(x: 0, y: 0, width: panelConfig.width, height: panelConfig.height),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false,
            configuration: panelConfig
        )
        
        let contentView = NSHostingView(rootView:
            ContentView()
                .frame(width: panelConfig.width, height: panelConfig.height)
        )
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = CGFloat(panelConfig.cornerRadius)
        contentView.layer?.masksToBounds = true
        
        panel.contentView = contentView
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
        panel.isMovable = false
        panel.hidesOnDeactivate = false
        
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            panel.setFrameOrigin(NSPoint(
                x: panelConfig.xOffset,
                y: screenFrame.maxY - panel.frame.height - panelConfig.yOffset
            ))
        }
        
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }
}

struct PanelConfiguration {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: Int
    let xOffset: CGFloat
    let yOffset: CGFloat
}
