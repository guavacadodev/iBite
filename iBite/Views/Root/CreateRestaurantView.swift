//
//  CreateRestaurantView.swift
//  iBite
//
//  Created by Jake Woodall on 1/3/25.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct CreateRestaurantView: View {
    @State private var navTitleImage = Image("iBiteTransparentBackground")
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var cuisine: Cuisines = .American
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @Binding var myRestaurants: [Restaurant]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Add a New Restaurant")
                        .font(.custom("Fredoka-Bold", size: 24))
                        .foregroundColor(Color("purple1"))

                    // Restaurant Splash Image Section
                    VStack {
                        // shows the selected image
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("teal1"), lineWidth: 2)
                                )
                        } else {
                            // otherwise if there is not an image, it defaults to the image picker
                            Button(action: {
                                showImagePicker = true
                            }) {
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color("teal1"))
                                    Text("Upload Splash Image")
                                        .font(.custom("Fredoka-Medium", size: 14))
                                        .foregroundColor(Color("lightGrayNeutral"))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("darkNeutral"))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                    Divider().background(Color("lightGrayNeutral"))

                    // Restaurant Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Restaurant Details")
                                .font(.custom("Fredoka-Bold", size: 20))
                                .foregroundColor(Color("purple1"))

                            TextField("Restaurant Name", text: $name)
                                .customTextFieldStyle(isEmpty: name.isEmpty)

                            TextField("Description", text: $description)
                                .customTextFieldStyle(isEmpty: name.isEmpty)

                            TextField("Location", text: $location)
                                .customTextFieldStyle(isEmpty: name.isEmpty)

                            CustomCuisinePicker(selectedCuisine: $cuisine)
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(Color("yellow1"))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("darkNeutral"))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("lightGrayNeutral"), lineWidth: 1)
                            )
                        }

                    }

                    .padding(.horizontal)

                    Divider().background(Color("lightGrayNeutral"))

                    // Save Button
                    Button(action: saveRestaurant) {
                        Text("Save Restaurant")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("teal1"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color("darkNeutral").ignoresSafeArea())
            //.navigationTitle("iBite").navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: navTitleImage.resizable().frame(width: 80, height: 80).offset(x: 140))
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("purple1"))
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    private func saveRestaurant() {
        guard !name.isEmpty, !location.isEmpty, let selectedImage = selectedImage else {
            print("Error: Name, location, and image cannot be empty.")
            return
        }

        let newRestaurant = Restaurant(
            name: name,
            cuisine: cuisine,
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), // Placeholder for location
            distance: 0.0,
            imageName: saveImageToDisk(selectedImage),
            models: [],
            menuItems: [],
            reviewText: nil,
            rating: nil
        )
        myRestaurants.append(newRestaurant)
        print("Created Restaurant: \(newRestaurant)")
        presentationMode.wrappedValue.dismiss()
    }

    private func saveImageToDisk(_ image: UIImage) -> String {
        // Save the image to disk and return the file name
        let fileName = "\(UUID().uuidString).jpg"
        if let data = image.jpegData(compressionQuality: 0.8) {
            let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try? data.write(to: path)
        }
        return fileName
    }
}


struct AddRestaurantButtonView: View {
    @State private var showCreateRestaurantView: Bool = false
    @State private var myRestaurants: [Restaurant] = []

    var body: some View {
        VStack {
            if myRestaurants.isEmpty {
                // Show the "Create a Restaurant" button when no restaurants exist
                Button(action: {
                    showCreateRestaurantView = true
                }) {
                    VStack {
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("teal1"))
                        Text("Create a Restaurant")
                            .font(.custom("Fredoka-Medium", size: 14))
                            .foregroundColor(Color("lightGrayNeutral"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("darkNeutral"))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showCreateRestaurantView) {
                    CreateRestaurantView(myRestaurants: $myRestaurants)
                }
            } else {
                // Show the horizontal slider with restaurants if restaurants exist
                MyRestaurantsHorizontalSliderView(myRestaurants: $myRestaurants)
            }
        }
    }
}


struct MyRestaurantsHorizontalSliderView: View {
    @Binding var myRestaurants: [Restaurant]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(myRestaurants, id: \.id) { restaurant in
                    VStack {
                        // Check if the image is saved on disk
                        if let imagePath = getSavedImagePath(for: restaurant.imageName),
                           let uiImage = UIImage(contentsOfFile: imagePath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        } else {
                            // Fallback to a default image
                            Image("defaultImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        }

                        Text(restaurant.name)
                            .font(.custom("Fredoka-Regular", size: 16))
                            .foregroundColor(Color("lightGrayNeutral"))

                        Text(restaurant.cuisine.rawValue)
                            .font(.custom("Fredoka-Regular", size: 14))
                            .foregroundColor(Color("teal1"))
                    }
                    .padding()
                    .background(Color("darkNeutral"))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
    }

    // Helper function to get the full path of the saved image
    private func getSavedImagePath(for fileName: String) -> String? {
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName).path
        return FileManager.default.fileExists(atPath: filePath) ? filePath : nil
    }
}

// Image Picker shown by default if image is not selected. Still needs an option to change image if an image is already selected.
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct CustomCuisinePicker: View {
    @Binding var selectedCuisine: Cuisines

    var body: some View {
        Menu {
            ForEach(Cuisines.allCases, id: \.self) { cuisine in
                Button(action: {
                    selectedCuisine = cuisine
                }) {
                    Text(cuisine.rawValue)
                        .font(.custom("Fredoka-Regular", size: 16))
                        .foregroundColor(cuisine == selectedCuisine ? Color("yellow1") : Color("lightGrayNeutral"))
                }
            }
        } label: {
            HStack {
                Text(selectedCuisine.rawValue)
                    .font(.custom("Fredoka-Bold", size: 18))
                    .foregroundColor(Color("yellow1")) // Selected cuisine color
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color("lightGrayNeutral"))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("darkNeutral"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("lightGrayNeutral"), lineWidth: 1)
            )
        }
    }
}

//
struct TextFieldModifier: ViewModifier {
    let isEmpty: Bool

    func body(content: Content) -> some View {
        content
            .font(.custom("Fredoka-Regular", size: 18))
            .padding()
            .accentColor(Color("yellow1"))
            .foregroundColor(isEmpty ? Color("lightGrayNeutral") : Color("whiteNeutral"))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("darkNeutral"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEmpty ? Color("lightGrayNeutral") : Color("yellow1"), lineWidth: 1)
            )
    }
}
extension View {
    func customTextFieldStyle(isEmpty: Bool) -> some View {
        self.modifier(TextFieldModifier(isEmpty: isEmpty))
    }
}






#Preview {
    CreateRestaurantView(myRestaurants: .constant([]))
}
