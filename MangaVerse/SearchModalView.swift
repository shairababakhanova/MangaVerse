
import SwiftUI

struct SearchModalView: View {
    @Binding var isPresented: Bool
    @State private var searchText: String = ""
    @State private var searchResults: [Manga] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var searchTask: Task<Void, Never>?
    var body: some View {
        NavigationStack {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    Text("Nothing found")
                        .foregroundColor(.gray)
                        .padding()
                } else if searchText.isEmpty {
                    Text("Enter your search term")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(searchResults) { manga in
                        NavigationLink(destination: MangaDetailView(mangaId: manga.id, mangaTitle: manga.title, coverURL: manga.coverURL)) {
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
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarItems(leading: Button("Close") {
                isPresented = false
            })
            .searchable(text: $searchText, prompt: "Searching...")
            .onChange(of: searchText) {newValue in
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await performSearch()
                }
            }
            
        }
    }
    
    private func performSearch() async {
        guard !searchText.isEmpty else {
            searchResults = []
            isLoading = false
            errorMessage = nil
            return
            
        }
        do {
            searchResults = []
            isLoading = true
            errorMessage = nil
            let mangas = try await MangaDexService.shared.searchManga(request: searchText)
            searchResults = mangas
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    SearchModalView(isPresented: .constant(true))
}
