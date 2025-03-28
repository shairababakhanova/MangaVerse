//
//  Authorization.swift
//  MangaRead
//
//  Created by Бабаханова Шаира on 08.03.2025.
//

import SwiftUI
import FirebaseAuth


struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    @Binding var currentUser: User?
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                Text("Sign In")
                    .navigationBarTitle("Authorization", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Authorization")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(alignment: .center)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
        
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .customIcons()
                        TextField("Email", text: $email)
                            .customTextField()
                    }
                    HStack{
                        Image(systemName: "lock")
                            .resizable()
                            .customIcons()
                        SecureField("Password", text: $password )
                            .customTextField()
                    }
                    VStack {
                        Button("Sign In") {
                            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                                if let user = result?.user {
                                    self.currentUser = User(name: "name", email: user.email ?? "", password: "", avatar: "")
                                    isLoggedIn = true
                                }else if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        .customButtonStyle(backgroundColor: .blue)
                        NavigationLink("I forgot password") {
                            Text("Страница для восстановления пароля")
                        }
                        .tint(.blue)
                        .frame(width: 200, height: 60)
                        HStack {
                            Text("New user?")
                            NavigationLink("Create account.") {
                                Registered(isLoggedIn: $isLoggedIn, currentUser: $currentUser)
                            }
                        }
                    } .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}



