import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "triangle.inset.filled")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                        
                        Text(wrappedText)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
    
    var wrappedText: String {
        let originalText = "hisome llonger textlonger textlonger tetextlonger textlonger tetextlonger textlonger tetextlonger textlonger tetextlonger textlonger tetextlonger textlonger tetextlonger textlonger textlonger textlonger textonger text"
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
