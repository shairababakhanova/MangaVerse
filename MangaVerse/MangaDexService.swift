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
    let description: [String: String]
    var status: String
    let year: Int
    var tags: [Tag]?
}
struct Tag: Codable {
    let attributes: TagAttributes
    
}

struct TagAttributes: Codable {
    let name: [String : String]
}

struct MangaDetailResponse: Codable {
    let result: String
    let response: String
    let data: MangaDexManga
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

struct ChapterResponse: Codable {
    let result: String
    let response: String
    let data: [Chapter]
}
struct Chapter: Codable, Hashable {
    let id: String
    let attributes: ChapterAttributes
}
struct ChapterAttributes: Codable, Hashable {
    let chapter: String?
    let title: String?
    let translatedLanguage: String
}

struct AtHomeResponse: Codable {
    let baseUrl: String
    let chapter: ChapterData
}

struct ChapterData: Codable {
    let hash: String
    let data: [String]
}

extension MangaDexService {
    func fetchChapters(forMangaId mangaId: String) async throws -> [Chapter] {
        let urlStr = "https://api.mangadex.org/chapter?manga=\(mangaId)&limit=10&translatedLanguage[]=en"
        guard let url = URL(string: urlStr) else {
            throw MangaDexError.invalidURL
        }
        print("Fetching chapters with URL: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200  else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("API Error Response: \(errorString)")
            }
            let errorResponse = try JSONDecoder().decode(MangaDexErrorResponse.self, from: data)
            throw MangaDexError.apiError(errorResponse.errors.first?.detail ?? "Unknown error")
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("API Response (fetchChapters): \(responseString)")
        }
        
        let chapterResponse = try JSONDecoder().decode(ChapterResponse.self, from: data)
        print("Fetched \(chapterResponse.data.count) chapters")
        return chapterResponse.data
    }
    
    func fetchChapterPages(forChapterId chapterId: String) async throws -> (baseUrl: String, pages: [String]) {
        let urlStr = "https://api.mangadex.org/at-home/server/\(chapterId)"
        guard let url = URL(string: urlStr) else {
            throw MangaDexError.invalidURL
        }
        print("Fetching chapter pages with URL: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("API Error Response: \(errorString)")
                    }
                    let errorResponse = try JSONDecoder().decode(MangaDexErrorResponse.self, from: data)
                    throw MangaDexError.apiError(errorResponse.errors.first?.detail ?? "Unknown error")
                }
        let atHomeResponse = try JSONDecoder().decode(AtHomeResponse.self, from: data)
        return (baseUrl: atHomeResponse.baseUrl, pages: atHomeResponse.chapter.data)
    }
}

extension MangaDexService {
    func fetchMangaDetails(forMangaId mangaId: String) async throws -> MangaDexManga {
        let encodedMangaId = mangaId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? mangaId
        let urlString = "https://api.mangadex.org/manga/\(encodedMangaId)?includes[]=cover_art"
        
        guard let url = URL(string: urlString) else {
            throw MangaDexError.invalidURL
        }
        print("Fetching manga details with URL: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MangaDexError.apiError("No HTTP response recieved")
        }
        guard httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("API Error Response (fetchMangaDetails): \(errorString)")
            }
            let errorResponse = try JSONDecoder().decode(MangaDexErrorResponse.self, from: data)
            throw MangaDexError.apiError(errorResponse.errors.first?.detail ?? "Unknown error (status: \(httpResponse.statusCode)")
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("API Response (fetchMangaDetails: \(responseString)")
        }
        
        let mangaDetailResponse = try JSONDecoder().decode(MangaDetailResponse.self, from: data)
        return mangaDetailResponse.data
    }
    
}

