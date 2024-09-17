import SwiftUI
import AppKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    let message: String
    @State private var timeRemaining: Double = 5.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()

            VStack {
                Text(message)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                
                Text(String(format: "%.1f", timeRemaining))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * 0.6, height: 10)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(colorScheme == .dark ? .white : .black)
                            .frame(width: 0.6 * geometry.size.width * CGFloat(timeRemaining / 5.0), height: 10)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
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
        }
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
