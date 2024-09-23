import AppKit
import SwiftUI

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
  var windows: [NSWindow] = []
  var dismissTimer: Timer?

  func applicationDidFinishLaunching(_ notification: Notification) {
    setupWindows(message: "Time to clock out")

    dismissTimer = Timer.scheduledTimer(
      withTimeInterval: 5.0, repeats: false
    ) { [weak self] _ in
      self?.dismissWindows()
    }
  }

  func setupWindows(message: String) {
    for screen in NSScreen.screens {
      let contentView = NSHostingView(
        rootView: ContentView(message: message))

      let window = NSWindow(
        contentRect: screen.frame,
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

      // Set the window's frame to match the screen's frame
      window.setFrame(screen.frame, display: true)

      window.makeKeyAndOrderFront(nil)
      self.windows.append(window)
    }
  }

  func dismissWindows() {
    for window in windows {
      window.close()
    }
    windows.removeAll()
    NSApp.terminate(nil)
  }
}
