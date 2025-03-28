//
//  LogoView.swift
//  MangaRead
//  Created by Бабаханова Шаира on 16.03.2025.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer(minLength: 40)
            Image("paw")
                .resizable()
                .frame(width: 130, height: 110)
                .scaledToFit() // Чтобы изображение сохраняло пропорции
                .frame(width: 130, height: 110)
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
            Text("MANGAVERSE")
                .foregroundColor(.blue)
                .font(.title2)
                .fontWeight(.bold)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
            Spacer(minLength: 50)
        }
    }
}

