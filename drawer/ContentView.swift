import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var isVisible = false
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "snowflake")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            Text(wrappedText)
                                .foregroundColor(.primary)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .opacity(isVisible ? 1 : 0)
                                .animation(.easeIn(duration: 0.5).delay(0.3), value: isVisible)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isVisible = true
            }
        }
    }
    
    var wrappedText: String {
        let originalText = "nix-rebuild switch done"
        return originalText.split(whereSeparator: { $0.isWhitespace })
            .reduce(into: "") { result, word in
                if (result.components(separatedBy: .newlines).last ?? "").count + word.count > 60 {
                    result += "\n\(word) "
                } else {
                    result += "\(word) "
                }
            }
            .trimmingCharacters(in: .whitespaces)
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
