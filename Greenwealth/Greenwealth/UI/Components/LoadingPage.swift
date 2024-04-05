import SwiftUI

struct LoadingPage: View {
    
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        ZStack{
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.primaryGreen, lineWidth: 10)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: Double(degree)))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear{
                    degree = 270 + 360
                    spinnerLength = 0
                }
            Text("Loading")
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    LoadingPage()
}
