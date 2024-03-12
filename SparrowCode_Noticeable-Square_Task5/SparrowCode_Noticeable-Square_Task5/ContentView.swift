import SwiftUI

private enum Constants {
    static let colors: [Color] = [.white, .pink, .yellow, .black]
    static let size: CGSize = .init(width: 100, height: 100)
}

struct ContentView: View {
    @State private var rects = [CGRect](repeating: .zero, count: 4)
    @State private var squarePosition: CGPoint = CGPoint(x: 200, y: 120)

    var body: some View {
        GeometryReader { proxy in
            ZStack() {
                VStack(spacing: 0) {
                    ForEach(Array(Constants.colors.enumerated()), id: \.offset) { id, color in
                        color.frame(height: proxy.size.height / 4)
                    }
                }

                MovableRect()
                    .frame(width: Constants.size.width, height: Constants.size.height)
                    .cornerRadius(16)
                    .position(squarePosition)
                    .gesture(MoveGesture())
            }
            .onAppear {
                for (index, _) in Constants.colors.enumerated() {
                    let height = proxy.size.height / 4
                    let width = proxy.frame(in: .global).width
                    rects[index] = .init(
                        origin: .init(x: 0, y: Int(height) * index),
                        size: .init(width: width, height: height)
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}

extension ContentView {
    @ViewBuilder
    private func MovableRect() -> some View {
        VStack(spacing: 0) {
            ForEach(Array(Constants.colors.enumerated()), id: \.offset) { index, _ in
                Rectangle()
                    .foregroundColor(index % 2 == 0 ? .black : .white)
                    .frame(height: calculatePartHeight(areaIndex: index))
            }
        }
    }

    private func calculatePartHeight(areaIndex: Int) -> CGFloat {
        let posX = squarePosition.x - Constants.size.width / 2
        let posY = squarePosition.y - Constants.size.height / 2
        let movableRect = CGRect(origin: .init(x: posX, y: posY), size: Constants.size)
        
        return rects[areaIndex].intersection(movableRect).height
    }
}

extension ContentView {
    private func MoveGesture() -> some Gesture {
        DragGesture(minimumDistance: 0).onChanged { newPosition in
            squarePosition = newPosition.location
        }
    }
}

#Preview {
    ContentView()
}
