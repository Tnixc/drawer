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
struct DrawerApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: CustomPanel?
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let arguments = CommandLine.arguments
        var message = "No message provided"
        var icon = "slash.circle.fill" // Default icon
        var duration = 2.0 // Default duration
        var iconColor = Color(hex: "#5DA5FF") // Default icon color
        var fgColor = Color(hex: "#BCCAFD") // Default foreground color
        var bgColor = Color(hex: "#24273C") // Default background color
        var position = "bottom-left" // Default position

        // Parse arguments
        for i in 1..<arguments.count {
            if arguments[i] == "--message" && i + 1 < arguments.count {
                message = arguments[i + 1]
            } else if arguments[i] == "--icon" && i + 1 < arguments.count {
                icon = arguments[i + 1]
            } else if arguments[i] == "--duration" && i + 1 < arguments.count {
                duration = Double(arguments[i + 1]) ?? 2.0
            } else if arguments[i] == "--icon-color" && i + 1 < arguments.count {
                iconColor = Color(hex: arguments[i + 1])
            } else if arguments[i] == "--fg-color" && i + 1 < arguments.count {
                fgColor = Color(hex: arguments[i + 1])
            } else if arguments[i] == "--bg-color" && i + 1 < arguments.count {
                bgColor = Color(hex: arguments[i + 1])
            } else if arguments[i] == "--pos" && i + 1 < arguments.count {
                position = arguments[i + 1].lowercased()
            }
        }

        setupPanel(message: message, icon: icon, duration: duration, iconColor: iconColor, fgColor: fgColor, bgColor: bgColor, position: position)
    }
    
    func setupPanel(message: String, icon: String, duration: Double = 2.0, iconColor: Color = Color(hex: "#5DA5FF"), fgColor: Color = Color(hex: "#BCCAFD"), bgColor: Color = Color(hex: "#24273C"), position: String = "top-right") {
        let cornerRadius: CGFloat = 16
        let xOffset: CGFloat = 15
        let yOffset: CGFloat = 15
        
        let contentView = NSHostingView(rootView: ContentView(message: message, icon: icon, iconColor: iconColor, fgColor: fgColor, bgColor: bgColor, onClose: closePanel ))
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
            var finalOrigin: NSPoint
            
            switch position {
            case "top-left":
                finalOrigin = NSPoint(x: screenFrame.minX + xOffset, y: screenFrame.maxY - contentView.frame.height - yOffset)
            case "top-center":
                finalOrigin = NSPoint(x: screenFrame.midX - contentView.frame.width / 2, y: screenFrame.maxY - contentView.frame.height - yOffset)
            case "top-right":
                finalOrigin = NSPoint(x: screenFrame.maxX - contentView.frame.width - xOffset, y: screenFrame.maxY - contentView.frame.height - yOffset)
            case "bottom-left":
                finalOrigin = NSPoint(x: screenFrame.minX + xOffset, y: screenFrame.minY + yOffset)
            case "bottom-center":
                finalOrigin = NSPoint(x: screenFrame.midX - contentView.frame.width / 2, y: screenFrame.minY + yOffset)
            case "bottom-right":
                finalOrigin = NSPoint(x: screenFrame.maxX - contentView.frame.width - xOffset, y: screenFrame.minY + yOffset)
            default:
                // Default to top-right if an invalid position is provided
                finalOrigin = NSPoint(x: screenFrame.maxX - contentView.frame.width - xOffset, y: screenFrame.maxY - contentView.frame.height - yOffset)
            }
            
            panel.setFrameOrigin(finalOrigin)
        }
        
        panel.orderFrontRegardless()
        self.panel = panel
        
        // Set up a timer to close the panel after the specified duration
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.closePanel()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.closePanel()
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
