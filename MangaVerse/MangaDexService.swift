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
    let relationships: [Relationship]?
    
    func coverURL(size: String = "512") -> URL? {
        guard let relationships = relationships,
              let coverRelationship = relationships.first(where: { $0.type == "cover_art" }),
              let fileName = coverRelationship.attributes?.fileName else {
            return nil
        }
        var urlString = "https://uploads.mangadex.org/covers/\(id)/\(fileName).\(size).jpg"
        return URL(string: urlString)
    }
    
}

struct Attributes: Codable {
    let title: [String: String]
}

struct Relationship: Codable {
    let id: String
    let type: String
    var attributes: RelationshipAttributes?
    
    
}

struct RelationshipAttributes: Codable {
    var fileName: String?
    
}
 
enum MangaCategory: String {
    case new = "new"
    case popular = "popular"
    case recomendations = "recomendations"
}


class MangaDexService {
    static let shared = MangaDexService(); private init() {}
    
    private func createURL(for category: MangaCategory) -> URL? {
        var urlStr = "https://api.mangadex.org/manga?limit=20&includes[]=cover_art"
        switch category {
        case .new:
            urlStr += "&order[createdAt]=desc"
        case .popular:
            urlStr += "&order[followedCount]=desc"
        case .recomendations:
            urlStr += "&order[rating]=desc"
            
        }
        let url = URL(string: urlStr)
        return url
    }
  
    
    
    func fetchData(for category: MangaCategory) async throws -> [Manga] {
        guard let url = createURL(for: category) else {
            throw MangaDexError.invalidURL
        }
        let (data, response)  = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Выводим сырые данные для отладки
                if let errorString = String(data: data, encoding: .utf8) {
                    print("API Error Response: \(errorString)")
                }
            let errorResponse = try JSONDecoder().decode(MangaDexErrorResponse.self, from: data)
                    throw MangaDexError.apiError(errorResponse.errors.first?.detail ?? "Unknown error")
                }

                // Выводим сырые данные для отладки
                if let responseString = String(data: data, encoding: .utf8) {
                    print("API Response: \(responseString)")
                }
        
        print("Fetching data for category \(category.rawValue) with URL: \(url)")
        let mangaResponse = try JSONDecoder().decode(MangaDexResponse.self, from: data)
        print("Relationships for first manga: \(mangaResponse.data.first?.relationships ?? [])")
        
        var mangas: [Manga] = []
        for manga in mangaResponse.data {
            let coverURL: URL? = manga.coverURL()
            mangas.append(
                Manga(
                    id: manga.id,
                    title: manga.attributes.title["en"] ?? "Unknown",
                    coverURL: coverURL,
                    localPath: nil,
                    isDownloaded: false
                )
            )
        }
        
        return mangas
        
    }
}
        
        
    
    
enum MangaDexError: Error {
    case invalidURL
    case apiError(String)
}
struct MangaDexErrorResponse: Codable {
    let result: String
    let errors: [MangaDexErrorDetail]
}
struct MangaDexErrorDetail: Codable {
    let id: String
    let status: Int
    let title: String
    let detail: String
    let context: String?
}

    

