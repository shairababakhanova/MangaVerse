import SwiftUI


struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var currentUser: User? = nil

    var body: some View {
        if isLoggedIn, let user = currentUser {
            ProfileView(user: user)
        } else {
            LogInView(isLoggedIn: $isLoggedIn, currentUser: $currentUser)
        }
    }
}

#Preview {
    ContentView()
}

