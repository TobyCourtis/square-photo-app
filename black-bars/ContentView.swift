//
//  ContentView.swift
//  black-bars
//
//  Created by Toby Courtis on 26/09/2020.
//  Copyright © 2020 Toby Courtis. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View{
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View{
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    // display the image
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    // select an image
                    self.showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)

                HStack {
                    Button("Change Filter") {
                        // change filter
                    }
    
                    Spacer()

                    Button("Save") {
                        guard let processedImage = self.processedImage else { return }
                        
                        // TOOD change image to square black photo and use it as the bottom image
                        let localAsset = UIImage(named: "TCT_Logo")
                        
                        if(localAsset != nil){
                            let mergedImage = UIImage.imageByMergingImages(topImage: processedImage, bottomImage: localAsset!)
                            print("merged")
                            
                            let imageSaver = ImageSaver()

                            imageSaver.successHandler = {
                                print("Success!")
                            }

                            imageSaver.errorHandler = {
                                print("Oops: \($0.localizedDescription)")
                            }

                            imageSaver.writeToPhotoAlbum(image: mergedImage)
                            print("Saved")
                        } else {
                            print("Failed to load top image")
                        }
                        
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("BlackBars")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
