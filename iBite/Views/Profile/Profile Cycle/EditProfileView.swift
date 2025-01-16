//
//  EditProfileView.swift
//  iBite
//
//  Created by Eslam on 14/01/2025.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the sheet
    @ObservedObject var viewModel: UserViewModel

    @State private var showAlert: Bool = false // State to control alert visibility

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    NormalTextFieldSwiftUI(type: UserNameFieldCase(), textValue: $viewModel.user.username)
                    NormalTextFieldSwiftUI(type: BirthdayFieldCase(), textValue: $viewModel.user.birthday)
                }
                MainButtonView(action: {
                    if viewModel.user.username.isEmpty || viewModel.user.birthday.isEmpty {
                        showAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, buttonTitle: "Save")
            }
        }
        .padding()
        .background(Color("darkNeutral"))
        .preferredColorScheme(.light)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Missing Information"),
                message: Text("Please fill out all fields to save your profile."),
                dismissButton: .default(
                    Text("OK").foregroundColor(Color.purple1) // Style with main color
                )
            )
        }
    }
}

//#Preview {
//    EditProfileView(user: <#T##UserModel#>)
//}

struct SignOutView: View {
    var body: some View {
        Text("Sign Out Screen")
            .font(.title)
            .padding()
    }
}
