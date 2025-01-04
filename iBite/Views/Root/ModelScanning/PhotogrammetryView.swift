//
//  PhotogrammetryView.swift
//  iBite
//
//  Created by Jake Woodall on 12/1/24.
//

import SwiftUI
import ARKit
import RealityKit
import AVKit

struct PhotogrammetryView: View {
    @EnvironmentObject var modelManager: ModelManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var isCapturing = false
    @State private var capturedImages: [UIImage] = [] // Stores images captured from the AR Capture View
    @State private var processingModel = false
    @State private var processedModelURL: URL? // Path to the processed 3D model
    @State private var menuItemName = ""
    @State private var menuItemPrice = ""
    @State private var menuItemIngredients = ""
    @State private var showModelSavedView = false // State to navigate to the new view
    @State private var currentQuality: String = "Acceptable"
    let navTitleImage = Image("iBiteTransparentBackground")

    var body: some View {
        NavigationView {
            VStack {
                if processingModel {
                    ProgressView("Processing Model...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let modelURL = processedModelURL {
                    // Preview the 3D model
                    Text("Preview Your Model")
                        .font(.headline)
                    Model3DView(modelURL: modelURL)
                        .frame(height: 300)

                    // Metadata form
                    VStack(alignment: .leading) {
                        TextField("Menu Item Name", text: $menuItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        TextField("Price (e.g., $12.99)", text: $menuItemPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        TextField("Ingredients (e.g., Flour, Butter)", text: $menuItemIngredients)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                    }
                    .padding()

                    // Save and upload
                    Button(action: saveMenuItem) {
                        Text("Save Menu Item")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .fullScreenCover(isPresented: $showModelSavedView) {
                        ModelSavedView(
                            modelURL: processedModelURL!,
                            name: menuItemName,
                            price: menuItemPrice,
                            ingredients: menuItemIngredients
                        )
                    }
                } else {
                    // Advanced photo capturing
                    ZStack {
                        // Use the AdvancedPhotoCaptureWrapperView
                        AdvancedPhotoCaptureWrapperView(
                            capturedImages: $capturedImages,
                            currentQuality: $currentQuality
                        )
                        .opacity(isCapturing ? 1 : 0)

                        // Instructions when not capturing
                        if !isCapturing {
                            VStack {
                                Text("How to Scan Your Menu Item")
                                    .font(.headline)
                                    .padding(.top)
                                VideoPlayerView(videoName: "scan_demo")
                                    .frame(height: 580)
                                    .cornerRadius(12)
                            }
                            .cornerRadius(12)
                            .padding()
                        }
                    }


                    // This button toggles the capturing of the menu item ( AdvancedPhotoCaptureView)
                    Button(action: toggleCapturing) {
                        Text(isCapturing ? "Stop Capturing" : "Start Capturing")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isCapturing ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    navTitleImage
                        .resizable()
                        .frame(width: 80, height: 80)
                        .offset(x: 85)
                }
            )
        }
    }

    func toggleCapturing() {
        isCapturing.toggle()
        if !isCapturing {
            // Process images after stopping capture
            startProcessingModel()
        }
    }

    func startProcessingModel() {
        guard !capturedImages.isEmpty else { return }
        processingModel = true
        PhotogrammetryProcessor.processImages(images: capturedImages) { result in
            DispatchQueue.main.async {
                processingModel = false
                switch result {
                case .success(let modelURL):
                    processedModelURL = modelURL
                case .failure(let error):
                    print("Failed to process model: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveMenuItem() {
        guard let modelURL = processedModelURL else { return }
        let newModel = ModelItem(
            url: modelURL,
            name: menuItemName,
            price: menuItemPrice,
            ingredients: menuItemIngredients
        )
        modelManager.models.append(newModel) // Add model to the shared manager

        // Trigger navigation to ModelSavedView
        showModelSavedView = true
    }
}


struct ModelSavedView: View {
    let modelURL: URL
    let name: String
    let price: String
    let ingredients: String

    @State private var navigateToModelCollection = false // State to handle navigation

    var body: some View {
        NavigationView {
            VStack {
                Text("Menu Item Saved!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Model3DView(modelURL: modelURL)
                    .frame(height: 300)
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(name)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Price: \(price)")
                        .font(.title3)
                    Text("Ingredients: \(ingredients)")
                        .font(.body)
                }
                .padding()
                
                Spacer()
                
                // NavigationLink to ModelCollectionView
                NavigationLink(
                    destination: ModelCollectionView(),
                    isActive: $navigateToModelCollection
                ) {
                    EmptyView()
                }

                Button(action: {
                    navigateToModelCollection = true // Trigger navigation
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationBarTitle("Model Saved", displayMode: .inline)
        }
    }
}


// A simple video player to display instructions
struct VideoPlayerView: View {
    let videoName: String

    var body: some View {
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mov") {
            VideoPlayer(player: AVPlayer(url: url))
        } else {
            Text("Video not found")
                .foregroundColor(.red)
        }
    }
}

// Placeholder for the 3D model preview
struct Model3DView: View {
    let modelURL: URL

    var body: some View {
        Text("3D Model Preview for \(modelURL.lastPathComponent)")
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

// Photogrammetry processing helper
struct PhotogrammetryProcessor {
    static func processImages(images: [UIImage], completion: @escaping (Result<URL, Error>) -> Void) {
        // Placeholder for actual photogrammetry processing
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let dummyURL = URL(fileURLWithPath: "/path/to/dummy_model.usdz")
            completion(.success(dummyURL))
        }
    }
}

#Preview {
    PhotogrammetryView()
}


