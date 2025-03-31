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
        let urlString = "https://uploads.mangadex.org/covers/\(id)/\(fileName).\(size).jpg"
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
 


class MangaDexService {
    static let shared = MangaDexService(); private init() {}
    
    private func createURL() -> URL? {
        let urlStr = "https://api.mangadex.org/manga?limit=20&includes[]=cover_art"
        let url = URL(string: urlStr)
        return url
    }
  
    
    
    func fetchData() async throws -> [Manga] {
        guard let url = createURL() else {
            throw MangaDexError.invalidURL
        }
        let (data, _)  = try await URLSession.shared.data(from: url)
        
        
        
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

    

