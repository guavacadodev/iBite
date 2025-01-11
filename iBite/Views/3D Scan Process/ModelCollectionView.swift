//
//  ModelCollectionView.swift
//  iBite
//
//  Created by Jake Woodall on 12/1/24.
//

import SwiftUI

struct ModelCollectionView: View {
    @EnvironmentObject var modelManager: ModelManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var showModelDetail = false
    @State private var selectedModel: ModelItem?

    var body: some View {
        NavigationView {
            VStack {
                if modelManager.models.isEmpty {
                    Text("No models created yet.")
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                            ForEach(modelManager.models) { model in
                                Button(action: {
                                    selectedModel = model
                                    showModelDetail = true
                                }) {
                                    VStack {
                                        Model3DView(modelURL: model.url)
                                            .frame(height: 120)
                                            .cornerRadius(8)
                                        Text(model.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("My Models", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showModelDetail) {
                if let model = selectedModel {
                    ModelDetailView(model: model)
                }
            }
        }
    }
}



