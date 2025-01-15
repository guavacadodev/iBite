//
//  AdvancedPhotoCaptureView.swift
//  iBite
//
//  Created by Jake Woodall on 12/8/24.
//

import SwiftUI
import AVFoundation
import CoreGraphics
import SceneKit
import ARKit
import RealityKit

struct AdvancedPhotoCaptureWrapperView: View {
    @Binding var capturedImages: [UIImage] // Stores captured images the user takes
    @Binding var currentQuality: String // Quality feedback that updates as each image is captured
    @State private var capturePoints: [AnchorEntity] = [] // Captures coordinate-based anchor points inside an array.

    var body: some View {
        ZStack {
            // AR Camera View
            ARViewContainer(capturePoints: $capturePoints, capturedImages: $capturedImages)
                .edgesIgnoringSafeArea(.all)

            // UI Controls
            VStack {
                Spacer()

                // Button and captured image preview
                HStack {
                    // Captured Image Preview
                    if let lastImage = capturedImages.last {
                        ZStack {
                            // Background with rounded corners
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.1)) // Placeholder background

                            // Display the captured image
                            Image(uiImage: lastImage)
                                .resizable()
                                .scaledToFill() // Ensures the image completely fills the frame
                                .frame(width: 70, height: 70) // Matches the size of the preview square
                                .clipped() // Clips the image to the frame
                                .rotationEffect(.degrees(90)) // Rotates the image 90 degrees clockwise
                        }
                        .frame(width: 70, height: 70) // Container frame
                        .cornerRadius(10) // Rounds the corners of the container
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2) // White border around the preview
                        )
                    } else {
                        // Placeholder square when no image is captured
                        Rectangle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .overlay(
                                Text("No Image")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            )
                    }



                    // Button to trigger AR object placement and photo capture
                    Button(action: {
                        // Post notification to trigger capture and model placement
                        NotificationCenter.default.post(name: .capturePhotoTriggered, object: nil)
                    }) {
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.red)
                            .overlay(
                                Text("Tap")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            )
                    }
                }
                .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var capturePoints: [AnchorEntity] // List of placed anchor entities
    @Binding var capturedImages: [UIImage] // Stores captured images for 3D model creation

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Configure the AR session
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)

        // Observer for the capturePhotoTriggered notification
        NotificationCenter.default.addObserver(forName: .capturePhotoTriggered, object: nil, queue: .main) { _ in
            capturePhoto(using: arView)
            placeModel(at: arView)
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func capturePhoto(using arView: ARView) {
        // Log the function call
        print("capturePhoto called")

        // Check if the current frame is available
        guard let currentFrame = arView.session.currentFrame else {
            print("Failed to capture current frame: AR session frame is nil")
            return
        }

        // Log that the frame was captured
        print("Current frame captured successfully")

        // Convert the current frame to a UIImage
        let ciImage = CIImage(cvPixelBuffer: currentFrame.capturedImage)
        let context = CIContext() // Use a context to create a CGImage
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            
            // Rotate the image by 90 degrees clockwise
            if let rotatedImage = uiImage.rotated(by: .pi / 2) { // 90 degrees in radians
                // Append the rotated image to the array
                capturedImages.append(rotatedImage)
                print("Rotated image appended. Total images: \(capturedImages.count)")
            } else {
                print("Failed to rotate image.")
            }
            
            // Append the captured image to the array
            capturedImages.append(uiImage)

            // Debug logs to verify the image and array contents
            print("Captured images array: \(capturedImages)")
            if let lastImage = capturedImages.last {
                print("Last image dimensions: \(lastImage.size.width) x \(lastImage.size.height)")
            } else {
                print("No images in the capturedImages array.")
            }
        } else {
            print("Failed to create CGImage from CIImage.")
        }
    }



    private func placeModel(at arView: ARView) {
        // Load the `.usdz` model
        guard let modelEntity = try? ModelEntity.load(named: "phone_outline") else {
            print("Failed to load model")
            return
        }
        
        // ** Scale the model **
        modelEntity.scale = SIMD3<Float>(0.04, 0.04, 0.04) // Adjust scale as needed (e.g., 80% of the original size)

        // Extract the camera's current position and direction
        let cameraTransform = arView.cameraTransform
        let cameraPosition = cameraTransform.matrix.translation
        let forwardDirection = normalize(-cameraTransform.matrix.columns.2.xyz)

        // Adjusts z position of the phone outline model
        let modelPosition = cameraPosition + forwardDirection * 0.1
        // Adjusts y position of the phone outline model
        var adjustedModelPosition = modelPosition
        adjustedModelPosition.y -= 0.05 // Move the model downwards by 0.2 meters

        // Align the model to face the camera
        let cameraOrientation = simd_quatf(cameraTransform.matrix)
        modelEntity.orientation = cameraOrientation

        // Create an anchor and add the model
        let anchor = AnchorEntity(world: adjustedModelPosition)
        anchor.addChild(modelEntity)

        // Add anchor to ARView
        arView.scene.addAnchor(anchor)

        // Update capture points
        capturePoints.append(anchor)
        print("Model placed at position: \(modelPosition)")
    }
}

extension UIImage {
    /// Rotates the image by the specified angle (in radians).
    func rotated(by radians: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.height, height: size.width))
        return renderer.image { context in
            context.cgContext.translateBy(x: size.height / 2, y: size.width / 2)
            context.cgContext.rotate(by: radians)
            context.cgContext.translateBy(x: -size.width / 2, y: -size.height / 2)
            draw(at: .zero)
        }
    }
}


extension simd_float4x4 {
    var translation: SIMD3<Float> {
        return [columns.3.x, columns.3.y, columns.3.z]
    }
}

extension simd_float4 {
    var xyz: SIMD3<Float> {
        return [x, y, z]
    }
}

extension Notification.Name {
    static let capturePhotoTriggered = Notification.Name("capturePhotoTriggered")
}



// UIKit-based custom camera controller
class CustomCameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    var delegate: CameraCaptureDelegate?

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.beginConfiguration()
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
        session.commitConfiguration()

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        delegate?.didCapturePhoto(image)
    }
}

// Protocol for handling photo capture events
protocol CameraCaptureDelegate {
    func didCapturePhoto(_ image: UIImage)
}

// Hashable wrapper for CGPoint
struct CapturePoint: Hashable {
    let id = UUID() // Unique identifier
    let point: CGPoint

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CapturePoint, rhs: CapturePoint) -> Bool {
        lhs.id == rhs.id
    }
}



