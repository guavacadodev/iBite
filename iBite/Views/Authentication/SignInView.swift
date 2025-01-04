////
////  SignInView.swift
////  iBite
////
////  Created by Jake Woodall on 10/25/24.
////
//
//import SwiftUI
//import ARKit
//import SceneKit
//import Firebase
//import FirebaseAuth
//import FirebaseAppCheck
//
//struct SignInView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var isAuthenticated = false
//    @State private var isShowingSignUp = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Welcome to iBite!")
//                    .font(.largeTitle)
//                    .padding()
//
//                TextField("Email", text: $email)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Button("Sign In") {
//                    authenticateUser()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .foregroundColor(.white)
//                .background(Color.blue)
//                .cornerRadius(10)
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                }
//
//                NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
//                    .padding()
//
//                Spacer()
//            }
//            .padding()
//            .fullScreenCover(isPresented: $isAuthenticated, content: ContentView.init)
//        }
//    }
//
//    func authenticateUser() {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                self.alertMessage = error.localizedDescription
//                self.showAlert = true
//            } else if let user = authResult?.user {
//                if user.isEmailVerified {
//                    self.isAuthenticated = true // Allow access
//                } else {
//                    self.alertMessage = "Please verify your email before signing in."
//                    self.showAlert = true
//                    try? Auth.auth().signOut()
//                }
//            }
//        }
//    }
//}



