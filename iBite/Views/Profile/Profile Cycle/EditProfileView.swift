//
//  EditProfileView.swift
//  iBite
//
//  Created by Eslam on 14/01/2025.
//

import SwiftUI

struct EditProfileView: View {
    var user: UserModel
    @State var userName = String()
    @State var bithdate = String()
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    NormalTextFieldSwiftUI(type: UserNameFieldCase(), textValue: $userName)
                    NormalTextFieldSwiftUI(type: BirthdayFieldCase(), textValue: $bithdate)
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


