import SwiftUI



struct ProfileView: View {
    let user: User

    var body: some View {
            VStack(alignment: .center, spacing: 20) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)
                
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)

            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
                Button(action: {
                // переход в настройки
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 30, height: 32)
                        .padding()
                }

            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("О себе")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        
        .padding()
        .navigationTitle("Профиль")
        List{
            Text("Избранное: Пока пусто")
                .font(.subheadline)
                .padding(.top, 5)
                .padding(.bottom, 20)
            Text("Витрина карточек: Пусто")
                .font(.subheadline)
                .padding(.top, 5)
                .padding(.bottom, 20)
            
        }
        VStack(alignment: .leading, spacing: 20) {
            Text("Комментарии")
                .font(.headline)
                .foregroundColor(.primary)
        }
        
    }
}


#Preview {
    ProfileView(user: User(name: "Шаира", email: "shairababakhanova@gmail.com", avatar: "person.circle"))
}

