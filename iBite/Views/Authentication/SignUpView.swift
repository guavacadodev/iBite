//
//  SignUpView.swift
//  iBite
//
//  Created by Jake Woodall on 10/25/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignIn = false

    var body: some View {
        VStack {
            Text("Create Your iBite Account")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                signUp()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.green) // Different color to distinguish from Sign In
            .cornerRadius(10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage == "Please verify your email to complete the sign-up process." {
                        isShowingSignIn = true // Redirect to SignInView
                    }
                })
            }

            Button("Already have an account? Sign In") {
                isShowingSignIn.toggle()
            }
            .padding()

            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $isShowingSignIn, content: SignInView.init)
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            } else if let user = authResult?.user {
                // Send verification email
                user.sendEmailVerification { error in
                    if let error = error {
                        self.alertMessage = "Failed to send verification email: \(error.localizedDescription)"
                    } else {
                        self.alertMessage = "Please verify your email to complete the sign-up process."
                    }
                    self.showAlert = true
                }
            }
        }
    }
}


