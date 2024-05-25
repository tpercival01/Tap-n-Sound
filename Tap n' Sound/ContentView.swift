import SwiftUI
import AVFoundation

struct ContentView: View {
    
    let images: [UIImage] = [
        UIImage(named: "A")!, UIImage(named: "B")!, UIImage(named: "C")!,
        UIImage(named: "D")!, UIImage(named: "E")!, UIImage(named: "F")!,
        UIImage(named: "G")!, UIImage(named: "H")!, UIImage(named: "I")!,
        UIImage(named: "J")!, UIImage(named: "K")!, UIImage(named: "L")!,
        UIImage(named: "M")!, UIImage(named: "N")!, UIImage(named: "O")!,
        UIImage(named: "P")!, UIImage(named: "Q")!, UIImage(named: "R")!,
        UIImage(named: "S")!, UIImage(named: "T")!, UIImage(named: "U")!,
        UIImage(named: "V")!, UIImage(named: "W")!, UIImage(named: "X")!,
        UIImage(named: "Y")!, UIImage(named: "Z")!, UIImage(named: "0")!,
        UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!,
        UIImage(named: "4")!, UIImage(named: "5")!, UIImage(named: "6")!,
        UIImage(named: "7")!, UIImage(named: "8")!, UIImage(named: "9")!
    ]
    
    @State private var displayedImages: [(image: UIImage, position: CGPoint, size: CGSize)] = []
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    
    var body: some View {
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.blue)
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            self.addImage(at: value.location)
                            self.playSound()
                        }
                )
            
            ForEach(0..<displayedImages.count, id: \.self) { index in
                Image(uiImage: displayedImages[index].image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: displayedImages[index].size.width, height: displayedImages[index].size.height)
                    .position(displayedImages[index].position)
                    .gesture(
                        TapGesture()
                            .onEnded {
                                self.addImage(at: displayedImages[index].position)
                                self.playSound()
                            }
                    )
            }
        }
    }
    
    private func addImage(at location: CGPoint) {
        let randomImage = images.randomElement()!
        let randomSize = CGSize(width: CGFloat.random(in: 100...300), height: CGFloat.random(in: 100...300))
        
        let newImage = (image: randomImage, position: location, size: randomSize)
        
        if displayedImages.count >= 10 {
            displayedImages.removeFirst()
        }
        
        displayedImages.append(newImage)
    }
    
    private func playSound() {
        audioPlayerManager.playRandomSound()
    }
}

class AudioPlayerManager: ObservableObject {
    private var audioPlayers: [AVAudioPlayer] = []
    private let soundFileNames: [String] = [
        "Audio 1_1", "Audio 2_1", "Audio 3_1", "Audio 4_1", "Audio 5_1",
        "Audio 6_1", "Audio 7_1", "Audio 8_1", "Audio 9_1", "Audio 10_1",
        "Audio 11_1", "Audio 12_1", "Audio 13_1", "Audio 14_1", "Audio 15_1",
        "Audio 16_1", "Audio 17_1", "Audio 18_1", "Audio 19_1", "Audio 20_1",
        "Audio 21_1", "Audio 22_1", "Audio 23_1", "Audio 24_1", "Audio 25_1",
        "Audio 26_1", "Audio 27_1"
    ]
    
    init() {
        // Preload audio players
        for fileName in soundFileNames {
            if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "wav") {
                do {
                    let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayers.append(audioPlayer)
                } catch {
                    print("Error loading sound file \(fileName): \(error.localizedDescription)")
                }
            }
        }
        
        // Configure AVAudioSession to allow mixing
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }
    
    func playRandomSound() {
        guard !audioPlayers.isEmpty else {
            print("No audio players available")
            return
        }
        
        let randomPlayer = audioPlayers.randomElement()!
        randomPlayer.play()
    }
}

#Preview {
    ContentView()
}
