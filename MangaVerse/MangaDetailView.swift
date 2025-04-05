//
//  MangaDetailView.swift
//  MangaVerse
//
//  Created by Бабаханова Шаира on 05.04.2025.
//

import SwiftUI

struct MangaDetailView: View {
    let mangaId: String
    let mangaTitle: String
    let coverURL: URL?
    
    @State private var mangaDetails: MangaDexManga?
    @State private var errorMessage: String?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if mangaDetails == nil {
                    ProgressView("Loading manga details...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    if let coverURL = coverURL {
                        AsyncImage(url: coverURL) {image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                        .padding(.horizontal)
                    }
                    HStack {
                        if let status = mangaDetails?.attributes.status  {
                            Text(status)
                                .foregroundColor(.green)
                                .font(.body)
                                .padding(.horizontal)
                        }
                        if let year = mangaDetails?.attributes.year {
                            Text("\(year)")
                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.horizontal)
                        }
                    }
                    
                    Text(mangaTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                    
                    if let tags = mangaDetails?.attributes.tags, !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.attributes.name) { tag in
                                    Text(tag.attributes.name["en"] ?? "Unknown")
                                        .font(.caption)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    if let description = mangaDetails?.attributes.description["en"] {
                        Text("Description")
                            .foregroundColor(.blue)
                            .font(.headline)
                            .padding(.horizontal)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Text("Description not available")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    NavigationLink(destination: ReaderView(mangaId: mangaId, mangaTitle: mangaTitle)) {
                        Text("Read Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(mangaTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                async let details = MangaDexService.shared.fetchMangaDetails(forMangaId: mangaId)
                mangaDetails = try await  details
            } catch {
                errorMessage = error.localizedDescription
            }
        }
       
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(
            mangaId: "some-manga-id", mangaTitle: "Test manga", coverURL: URL(string: "https://example.com/cover.jpg")
        )
    }
}
