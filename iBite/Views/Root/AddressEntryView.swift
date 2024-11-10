//
//  AddressEntryView.swift
//  iBite
//
//  Created by Jake Woodall on 11/1/24.
//

import SwiftUI
import MapKit

struct AddressEntryView: View {
    @Binding var enteredAddress: String
    @Environment(\.presentationMode) var presentationMode
    
    // Properties for address suggestions
    @State private var searchText = ""
    @StateObject private var completerDelegate = CompleterDelegate() // Manages search results

    var body: some View {
        VStack {
            Text("Enter Your Address")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 20)

            // Text field for entering an address
            TextField("Enter address...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { newValue in
                    completerDelegate.searchCompleter.queryFragment = newValue
                }

            // Displaying search results in a List
            List(completerDelegate.results, id: \.title) { result in
                Text(result.title)
                    .onTapGesture {
                        searchText = result.title // Select address suggestion
                    }
            }
            
            // Save button to save the address and close the view
            Button("Save") {
                enteredAddress = searchText // Save the selected address
                presentationMode.wrappedValue.dismiss() // Close the view
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
        }
        .onAppear {
            completerDelegate.setupCompleter() // Initialize completer settings
        }
    }
}

// CompleterDelegate class to handle MKLocalSearchCompleterDelegate
class CompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results = [MKLocalSearchCompletion]()
    var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func setupCompleter() {
        searchCompleter.delegate = self
        print("Search Completer setup completed")
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        print("Search results updated: \(completer.results.map { $0.title })")
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error finding address suggestions: \(error.localizedDescription)")
        self.results = [] // Clear results if search fails
    }
}







