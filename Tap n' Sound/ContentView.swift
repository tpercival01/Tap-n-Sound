//
//  ContentView.swift
//  Tap n' Sound
//
//  Created by Thomas Percival on 21/04/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    let images: [UIImage] = [UIImage(named: "A")!, UIImage(named: "B")!, UIImage(named: "C")!, UIImage(named: "D")!, UIImage(named: "E")!, UIImage(named: "F")!, UIImage(named: "G")!, UIImage(named: "H")!, UIImage(named: "I")!, UIImage(named: "J")!, UIImage(named: "K")!, UIImage(named: "L")!, UIImage(named: "M")!]
        
    @State private var selectedImage: UIImage? // Store the selected image
    @State private var imageSize: CGSize = CGSize(width: 100, height: 100) // Initial size of the image
    @StateObject private var audioPlayer = AudioManager()
    
    var body: some View {
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.blue)
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.selectRandomImage()
                    self.playSound()
                }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize.width, height: imageSize.height) // Set the size of the image
                    .position(x: CGFloat.random(in: imageSize.width/2...UIScreen.main.bounds.width-imageSize.width/2), y: CGFloat.random(in: imageSize.height/2...UIScreen.main.bounds.height-imageSize.height/2)) // Randomize the position of the image
                    .onTapGesture {
                        self.selectRandomImage()
                        self.playSound()
                    }
            }
        }
    }
    
    private func selectRandomImage() {
        self.selectedImage = self.images.randomElement()
        self.imageSize = CGSize(width: CGFloat.random(in: 100...300), height: CGFloat.random(in: 100...300)) // Randomize the size of the image
    }
    
    private func playSound() {
        audioPlayer.playRandomSound()
    }
}

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    let soundFileNames = ["sound1", "sound2", "sound3"]

    func playRandomSound() {
        guard let soundFileName = soundFileNames.randomElement() else {
            print("No sound file found")
            return
        }
        
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}




#Preview {
    ContentView()
}
