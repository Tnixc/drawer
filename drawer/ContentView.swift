import AppKit
import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  let message: String
  @State private var timeRemaining: Double = 5.0
  @State private var currentTime = Date()
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  let BAR_SCALE_FAC = 0.4

  var body: some View {
    ZStack {
      VisualEffectView(material: .popover, blendingMode: .behindWindow)
        .ignoresSafeArea()

      VStack(spacing: 20) {
        Text(message)
          .font(.system(size: 48, weight: .bold))
          .foregroundStyle(.primary)
          .multilineTextAlignment(.center)

        Text("The time is \(formattedTime)")
          .font(.system(size: 36, weight: .medium))
          .foregroundStyle(.primary)

        Text(String(format: "%.1f", timeRemaining))
          .font(.system(size: 24))
          .foregroundStyle(.secondary)
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
              .fill(.regularMaterial)
              .frame(
                width: geometry.size.width * BAR_SCALE_FAC,
                height: 10)

            RoundedRectangle(cornerRadius: 5)
              .fill(.primary)
              .frame(
                width: BAR_SCALE_FAC * geometry.size.width
                  * CGFloat(timeRemaining / 5.0), height: 10)
          }
          .frame(
            width: geometry.size.width, height: geometry.size.height
          )
        }
        .frame(height: 10)
        .padding(.horizontal)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .onReceive(timer) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 0.1
      }
      currentTime = Date()
    }
  }

  var formattedTime: String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: currentTime)
  }
}

struct VisualEffectView: NSViewRepresentable {
  let material: NSVisualEffectView.Material
  let blendingMode: NSVisualEffectView.BlendingMode

  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = material
    view.blendingMode = blendingMode
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
