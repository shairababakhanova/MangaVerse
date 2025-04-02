//
//  MainPage.swift
//  MangaVerse
//
//  Created by Бабаханова Шаира on 21.03.2025.
//

import SwiftUI

struct MainPage: View {
    @State private var mangaList: [Manga] = []
    @State private var errorMessage: String?
    @State private var selectedCategory: MangaCategory = .recomendations

    var body: some View {
            VStack{
                Picker("Category", selection: $selectedCategory) {
                    Text("Recomendations").tag(MangaCategory.recomendations)
                    Text("Popular").tag(MangaCategory.popular)
                    Text("New").tag(MangaCategory.new)
                    
                        
                }
            }.pickerStyle(.segmented)
            .padding()
        
        
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                List(mangaList) { manga in
                    HStack {
                        if let coverURL = manga.coverURL {
                            AsyncImage(url: coverURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 130)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 90, height: 130)
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 90, height: 130)
                                .cornerRadius(8)
                        }

                        Text(manga.title)
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
                .navigationTitle("Manga")
                
                .task(id: selectedCategory) {
                    do {
                        mangaList = []
                        let mangas = try await MangaDexService.shared.fetchData(for: selectedCategory)
                        mangaList = mangas
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
