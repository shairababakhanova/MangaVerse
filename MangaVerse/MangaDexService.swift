//
//  MangaDexService.swift
//  MangaVerse
//
//  Created by Бабаханова Шаира on 28.03.2025.
//

import Foundation

struct MangaDexResponse: Codable {
    let data: [MangaDexManga]
}

struct MangaDexManga: Codable {
    let id: String
    let attributes: Attributes
    
    struct Attributes: Codable {
        let title: [String: String]
    }
}

class MangaDexService {
    static let shared = MangaDexService(); private init() {}
    private func createURL() -> URL? {
        let urlStr = "https://api.mangadex.org/manga?limit=10"
        let url = URL(string: urlStr)
        return url
    }
    func fetchData() async throws -> [Manga] {
        guard let url = createURL() else {
            throw MangaDexError.invalidURL
        }
        let (data, _)  = try await URLSession.shared.data(from: url)
        
        
        let mangaResponse = try JSONDecoder().decode(MangaDexResponse.self, from: data)
        
        return mangaResponse.data.map {
            Manga(id: $0.id, title: $0.attributes.title["en"] ?? "Unknown", localPath: nil, isDownloaded: false)
        }
        
        
        
    }
    
}

enum MangaDexError: Error {
    case invalidURL
    case apiError(String)
}



