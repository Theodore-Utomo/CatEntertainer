import SwiftUI

struct ContentView: View {
    @State private var positionX = 0.0
    @State private var positionY = 0.0
    @State private var isMoving = false
    @State private var timer: Timer? = nil //Timer for moving fish around screen
    @State private var speedOfIcon = 1.0 //Used to calculate speed
    @State private var iconAngle: Double = 0.0 //Used to calculate angle and rotate icon
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Image(systemName: "tennisball.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.indigo)
                    .offset(x: positionX, y: positionY)
                    .rotationEffect(Angle(degrees: iconAngle))  // Rotate the fish based on the calculated angle
                    .animation(.easeInOut(duration: 2.0 / speedOfIcon), value: positionX)
                    .animation(.easeInOut(duration: 2.0 / speedOfIcon), value: positionY)
                
                Spacer()
                
                HStack {
                    Button(isMoving ? "Stop Ball" : "Move Ball") {
                        if isMoving {
                            stopMoving()
                        } else {
                            startMoving(in: geometry.size)
                        }
                    }
                    .cornerRadius(10)

                    Spacer()
                    Button("Reset Ball") {
                        stopMoving()
                        positionX = 0.0
                        positionY = 0.0
                        speedOfIcon = 1.0
                        iconAngle = 0.0
                    }
                    .cornerRadius(10)

                }
                .frame(width: 250, height: 30)
                .font(.custom("bottom", fixedSize: 14))
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.indigo)
                        .frame(height: 30)
                    Stepper("Speed of Ball: \(speedOfIcon, specifier: "%.1f")", value: $speedOfIcon, in: 0.1...2.0, step: 0.1)
                        .frame(height: 20)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .font(.custom("bottom", fixedSize: 14))
                }
                .frame(width: 250)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Updated to pass GeometryProxy size directly for clarity
    func startMoving(in size: CGSize) {
        isMoving = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.0 / speedOfIcon)) {
                let lowerLimitWidth = -size.width / 2 + 50
                let upperLimitWidth = size.width / 2 - 50
                let lowerLimitHeight = -size.height / 2 + 150
                let upperLimitHeight = size.height / 2 - 150
                //Limits bounds to within screen
                
                let newPositionX = Double.random(in: lowerLimitWidth...upperLimitWidth)
                let newPositionY = Double.random(in: lowerLimitHeight...upperLimitHeight) //Randomize movement
                //Calculates angle from change in position
                let deltaX = newPositionX - positionX
                let deltaY = newPositionY - positionY
                //Updates Icon Angle
                iconAngle = calculateAngle(deltaX: deltaX, deltaY: deltaY)
                //Updates Icon Position
                positionX = newPositionX
                positionY = newPositionY
            }
        }
    }
    
    func stopMoving() {
        isMoving = false
        timer?.invalidate()
        timer = nil
    }
    
    func calculateAngle(deltaX: Double, deltaY: Double) -> Double {
        let angle = atan2(deltaY, deltaX)
        return angle * 180 / .pi  // Convert to degrees
    }
}

#Preview {
    ContentView()
}
