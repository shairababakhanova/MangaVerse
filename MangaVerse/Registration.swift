//


//
//  Created by Бабаханова Шаира on 08.03.2025.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct Registered: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @Binding  var isLoggedIn: Bool
    @Binding var currentUser: User?
    @Environment(\.dismiss) var dismiss // позволяет закрыть текущий экран
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LogoView()
                Text("Register your account")
                    .navigationBarTitle("Registration", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Registration")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(alignment: .center)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .customIcons()
                    TextField("Name", text: $name)
                        .customTextField()
                }
                
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
                    Button("Sign Up") {
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            if let user = result?.user {
                                self.currentUser = User(name: name, email: user.email ?? "", password: "", avatar: "default" )
                            }
                        }
                    }
                    .customButtonStyle(backgroundColor: .blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }
        }
        
        
        
    }
}

    




