//
//  ChangePasswordView.swift
//  iBite
//
//  Created by Eslam on 15/01/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @State var currentPassword = String()
    @State var isSecureCurrentPassword = Bool()
    @State var newPassword = String()
    @State var isSecureNewPassword = Bool()
    @State var confirmNewPassword = String()
    @State var isSecureconfirmNewPassword = Bool()
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    SecureFieldViewSwiftUI(type: CurrentPasswordFieldCase(), textValue: $currentPassword, isSecure: $isSecureCurrentPassword, isSecureField: true)
                    SecureFieldViewSwiftUI(type: NewPasswordFieldCase(), textValue: $newPassword, isSecure: $isSecureNewPassword, isSecureField: true)
                    SecureFieldViewSwiftUI(type: ConfirmPasswordFieldCase(), textValue: $confirmNewPassword, isSecure: $isSecureconfirmNewPassword, isSecureField: true)
                }
                
                MainButtonView(action: {
                    print("")
                }, buttonTitle: "Save")
            }
        }
        .padding()
        .background(Color("darkNeutral"))
        .preferredColorScheme(.light)
        .navigationBarTitleTextColor(Color.violet1)
    }
}
