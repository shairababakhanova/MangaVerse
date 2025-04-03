import SwiftUI

struct ReaderView: View {
    let mangaId: String
    let mangaTitle: String
    @State private var chapters: [Chapter] = []
    @State private var selectedChapter: Chapter?
    @State private var pageUrls: [URL] = []
    @State private var currentPage: Int = 0
    @State private var errorMessage: String?
    @State private var isLoadingPages: Bool = false

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if chapters.isEmpty {
                ProgressView("Loading chapters...")
                    .onAppear {
                        Task {
                            do {
                                let fetchedChapters = try await MangaDexService.shared.fetchChapters(forMangaId: mangaId)
                                
                                if fetchedChapters.isEmpty {
                                    errorMessage = "No chapters found for this manga."
                                }
                                chapters = fetchedChapters
                                if let firstChapter = fetchedChapters.first {
                                    selectedChapter = firstChapter
                                    await loadPages(for: firstChapter)
                                }
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
            } else if pageUrls.isEmpty && !isLoadingPages {
                ProgressView("Loading pages...")
            } else {
                ZStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<pageUrls.count, id: \.self) { index in
                            AsyncImage(url: pageUrls[index]) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .overlay(alignment: .bottom) {
                        Text("Page \(currentPage + 1) of \(pageUrls.count)")
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 20)
                    }

                    if isLoadingPages {
                        ProgressView("Loading pages...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.3))
                    }
                }

                Picker("Chapter", selection: $selectedChapter) {
                    ForEach(chapters, id: \.id) { chapter in
                        Text("Chapter \(chapter.attributes.chapter ?? "N/A")")
                            .tag(chapter as Chapter?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedChapter) { newChapter in
                    if let chapter = newChapter {
                        Task {
                            await loadPages(for: chapter)
                        }
                    }
                }
            }
        }
        .navigationTitle(mangaTitle)
    }

    private func loadPages(for chapter: Chapter) async {
        isLoadingPages = true
        defer { isLoadingPages = false }
        do {
            let (baseUrl, pages) = try await MangaDexService.shared.fetchChapterPages(forChapterId: chapter.id)
            if pages.isEmpty {
                errorMessage = "No pages found for this chapter."
                pageUrls = []
                return
            }
            pageUrls = pages.compactMap { page in
                URL(string: "\(baseUrl)/data/\(page)")
            }
            if pageUrls.isEmpty {
                errorMessage = "Failed to create page URLs."
            }
            currentPage = 0
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(mangaId: "some-manga-id", mangaTitle: "Test Manga")
    }
}
