import SwiftUI

@main
struct MyViewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            YellowScreenView()
                .tag(0)
            
            RedCircleView()
                .tag(1)
            
            AlphabetJiggleView()
                .tag(2)
            
            FormView()
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}
#Preview("Everything") {
  ContentView()
}

struct YellowScreenView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 100)
                .border(Color.black, width: 2)
            
            Spacer()
            
            ScrollView {
                VStack {
                    ForEach(8..<37, id: \.self) { size in
                        Text("The quick brown fox jumped over the lazy dog")
                            .font(.system(size: CGFloat(size)))
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 2)
                    }
                }
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
            }
            
            Spacer()
            
            Rectangle()
                .fill(Color.red)
                .frame(height: 100)
                .border(Color.white, width: 2)
        }
        .padding()
        .background(Color.yellow)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview("Yellow Screen View") {
    YellowScreenView()
}

struct RedCircleView: View {
    @State private var ballPositions: [CGSize] = [
        CGSize(width: 50, height: 50),
        CGSize(width: -50, height: -50),
        CGSize(width: 30, height: -30),
        CGSize(width: -30, height: 30)
    ]
    
    let ballSize: CGFloat = 40
    
    var body: some View {
        GeometryReader { geometry in
            let circleRadius = geometry.size.width / 2
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: ballSize, height: ballSize)
                        .offset(ballPositions[index])
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: ballPositions[index])
                        .onAppear {
                            let randomX = CGFloat.random(in: -circleRadius + ballSize/2...circleRadius - ballSize/2)
                            let randomY = CGFloat.random(in: -circleRadius + ballSize/2...circleRadius - ballSize/2)
                            ballPositions[index] = CGSize(width: randomX, height: randomY)
                        }
                        .onChange(of: ballPositions[index]) { oldPosition, newPosition in
                            let x = newPosition.width
                            let y = newPosition.height
                            let distanceFromCenter = sqrt(x * x + y * y)
                            let maxDistance = circleRadius - ballSize / 2
                            if distanceFromCenter > maxDistance {
                                let scaleFactor = maxDistance / distanceFromCenter
                                ballPositions[index] = CGSize(width: x * scaleFactor, height: y * scaleFactor)
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview("Red Circle View") {
    RedCircleView()
}

struct AlphabetJiggleView: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    @State private var positions: [CGFloat] = Array(repeating: -100, count: 26)  // Start above the screen
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(0..<26, id: \.self) { index in
                    Text(String(letters[index]))
                        .font(.largeTitle)
                        .foregroundColor(isVowel(letter: letters[index]) ? .blue : .white)
                        .position(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height / 2)
                        .offset(y: positions[index])
                        .onAppear {
                            withAnimation(Animation.interpolatingSpring(stiffness: 50, damping: 8).repeatForever(autoreverses: false).delay(Double(index) * 0.2)) {
                                positions[index] = geometry.size.height / 2 + CGFloat.random(in: -100...100)
                            }
                        }
                }
            }
        }
    }
    
    private func isVowel(letter: Character) -> Bool {
        return "AEIOU".contains(letter)
    }
}

#Preview("Alphabet Jiggle View") {
    AlphabetJiggleView()
}

struct FormView: View {
    @State private var sliderValue: Double = 50
    @State private var selectedColor: Color = .blue
    @State private var isToggled: Bool = false
    @State private var selectedPickerValue = "Option 1"
    
    let pickerOptions = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        Form {
            Section(header: Text("Controls")) {
                Slider(value: $sliderValue, in: 0...100, step: 1) {
                    Text("Slider Value")
                }
                Text("Slider Value: \(Int(sliderValue))")
                
                Toggle(isOn: $isToggled) {
                    Text("Toggle Switch")
                }
                
                Picker("Pick an Option", selection: $selectedPickerValue) {
                    ForEach(pickerOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                
                ColorPicker("Pick a Color", selection: $selectedColor)
            }
            
            Section {
                Button("Submit") {
                    print("Form submitted")
                }
                
                Button("Reset") {
                    sliderValue = 50
                    isToggled = false
                    selectedPickerValue = "Option 1"
                    selectedColor = .blue
                }
            }
        }
        .navigationTitle("Form Example")
    }
}

#Preview("Form View") {
  NavigationView {
    FormView()
  }
}

